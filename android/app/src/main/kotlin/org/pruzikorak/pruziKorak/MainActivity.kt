package org.pruzikorak.pruziKorak

import android.os.Handler
import android.os.Looper
import android.Manifest
import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.google.android.gms.auth.api.signin.GoogleSignIn
import com.google.android.gms.auth.api.signin.GoogleSignInOptions
import com.google.android.gms.fitness.Fitness
import com.google.android.gms.fitness.FitnessOptions
import com.google.android.gms.fitness.data.DataType
import com.google.android.gms.fitness.data.Field
import com.google.android.gms.fitness.request.OnDataPointListener
import com.google.android.gms.fitness.request.DataReadRequest
import com.google.android.gms.fitness.request.SensorRequest

import androidx.health.connect.client.HealthConnectClient
import androidx.health.connect.client.permission.HealthPermission
import androidx.health.connect.client.records.DistanceRecord
import androidx.health.connect.client.request.AggregateGroupByDurationRequest
import androidx.health.connect.client.time.TimeRangeFilter
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.time.Duration
import java.time.Instant
import java.time.LocalDate
import java.time.ZoneId
import java.time.format.DateTimeFormatter
import kotlinx.coroutines.launch
import java.time.Instant
import java.text.SimpleDateFormat
import java.util.TimeZone
import java.util.concurrent.TimeUnit

class MainActivity : FlutterActivity() {
    companion object {
        private const val CHANNEL_NAME = "org.pruziKorak.healthkit/callback"
        private const val SIGN_IN_REQUEST_CODE = 9001
        private const val ACTIVITY_RECOGNITION_REQUEST_CODE = 1002
        private const val GOOGLE_FIT_PERMISSIONS_REQUEST_CODE = 1001

        private const val EVENTS_NAME = "org.pruziKorak.healthkit/step_events"

        private const val METERS_PER_STEP = 1000.0 / 1300.0    // ~0.769m po koraku (1300 steps = 1km)
        private const val DIST_THRESHOLD_METERS = 5.0        // emituje tek kad pređeš 5m
        private const val MIN_EMIT_INTERVAL_MS = 10_000L       // minimalni razmak između emitovanja (anti-spam)
        private const val MAX_SILENCE_MS = 5 * 60_000L         // ipak emituje bar na 5 min (da UI ne "zamre")
    }

    private lateinit var channel: MethodChannel

    private var stepListener: OnDataPointListener? = null
    private val mainHandler = Handler(Looper.getMainLooper())

    private var distanceSinceLastEmit = 0.0
    private var lastEmitAt = 0L

    private var pendingStepCall: Pair<MethodChannel.Result, () -> Unit>? = null
    private var pendingActivityPermissionCall: Pair<MethodChannel.Result, () -> Unit>? = null
    private var pendingFitPermissionCall: Pair<MethodChannel.Result, () -> Unit>? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NAME)

        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "startStepListener" -> {
                    ensureSignedInThen {
                        ensureActivityPermissionThen {
                            ensureFitPermissionThen {
                                registerStepSensor()
                            }
                        }
                    }
                    result.success(null)
                }

                "stopStepListener" -> {
                    unregisterStepSensor()
                    result.success(null)
                }

                "getKilometersGroupedByDay" -> {
                    val ts = call.arguments as? Double
                    if (ts == null) {
                        result.error("INVALID_ARGUMENT", "Expected timestamp", null)
                    } else {
                        val start = (ts * 1000).toLong()
                        val end = System.currentTimeMillis()
                        ensureHealthConnectPermissions {
                            getKilometersGroupedByDay(start, end, result)
                        }
                    }

                }

                "getTodayKilometersSinceLastSync" -> {
                    val ts = call.arguments as? Double
                    if (ts == null) {
                        result.error("INVALID_ARGUMENT", "Expected timestamp", null)
                    } else {
                        val start = (ts * 1000).toLong()
                        val now = System.currentTimeMillis()

                        ensureHealthConnectPermissions(result) {
                            getKilometers(start, now, result)
                        }
                    }
                }

                else -> result.notImplemented()
            }
        }
    }
// New Code block:

    private const val HEALTH_CONNECT_PERMISSIONS_REQUEST_CODE = 1101
    private var pendingHealthConnectPermissionCall: Pair<MethodChannel.Result, () -> Unit>? = null

    private fun ensureHealthConnectPermissions(
        result: MethodChannel.Result,
        onGranted: () -> Unit
    ) {
        if (!HealthConnectClient.isAvailable(this)) {
            result.error("HC_NOT_AVAILABLE", "Health Connect is not available on this device", null)
            return
        }

        val client = HealthConnectClient.getOrCreate(this)
        val required = setOf(
            HealthPermission.getReadPermission(DistanceRecord::class)
            // + StepsRecord ako ti treba kasnije
        )

        CoroutineScope(Dispatchers.IO).launch {
            val granted = client.permissionController.getGrantedPermissions()
            if (granted.containsAll(required)) {
                CoroutineScope(Dispatchers.Main).launch { onGranted() }
            } else {
                val intent = client.permissionController.createRequestPermissionIntent(required)
                pendingHealthConnectPermissionCall = result to onGranted
                startActivityForResult(intent, HEALTH_CONNECT_PERMISSIONS_REQUEST_CODE)
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (requestCode == HEALTH_CONNECT_PERMISSIONS_REQUEST_CODE) {
            val (res, onGranted) = pendingHealthConnectPermissionCall ?: return
            pendingHealthConnectPermissionCall = null

            ensureHealthConnectPermissions(res) { onGranted() }
            return
        }
    }

    private fun getKilometers(
        startTime: Long,
        endTime: Long,
        result: MethodChannel.Result
    ) {
        // Health Connect availability check (optional but recommended)
        if (!HealthConnectClient.isAvailable(this)) {
            result.error("HC_NOT_AVAILABLE", "Health Connect is not available on this device", null)
            return
        }

        val healthConnectClient = HealthConnectClient.getOrCreate(this)

        // Health Connect calls are suspend-based, so run in coroutine
        CoroutineScope(Dispatchers.IO).launch {
            try {
                // Optional: verify permissions here (or do it earlier in your flow)
                // If you already do permission gating in your method chain, you can remove this block.
                val requiredPermissions = setOf(
                    HealthPermission.getReadPermission(DistanceRecord::class)
                )
                val granted = healthConnectClient.permissionController.getGrantedPermissions()
                if (!granted.containsAll(requiredPermissions)) {
                    CoroutineScope(Dispatchers.Main).launch {
                        result.error("PERMISSION_DENIED", "Health Connect read permission not granted", null)
                    }
                    return@launch
                }

                val aggregateRequest = AggregateRequest(
                    metrics = setOf(DistanceRecord.DISTANCE_TOTAL),
                    timeRangeFilter = TimeRangeFilter.between(
                        Instant.ofEpochMilli(startTime),
                        Instant.ofEpochMilli(endTime)
                    )
                )

                val response: AggregationResult = healthConnectClient.aggregate(aggregateRequest)

                // DISTANCE_TOTAL is returned as Length, typically in meters
                val totalMeters = response[DistanceRecord.DISTANCE_TOTAL]?.inMeters ?: 0.0
                val kilometers = totalMeters / 1000.0

                CoroutineScope(Dispatchers.Main).launch {
                    result.success(kilometers)
                }
            } catch (e: Exception) {
                CoroutineScope(Dispatchers.Main).launch {
                    result.error("HC_ERROR", "Failed to read distance: ${e.localizedMessage}", null)
                }
            }
        }
    }

    private fun getKilometersGroupedByDay(
        startTime: Long,
        endTime: Long,
        result: MethodChannel.Result
    ) {
        if (!HealthConnectClient.isAvailable(this)) {
            result.error("HC_NOT_AVAILABLE", "Health Connect is not available on this device", null)
            return
        }

        val healthConnectClient = HealthConnectClient.getOrCreate(this)

        CoroutineScope(Dispatchers.IO).launch {
            try {
                // Optional: permission check (if you already gate before calling, you can remove)
                val requiredPermissions = setOf(
                    HealthPermission.getReadPermission(DistanceRecord::class)
                )
                val granted = healthConnectClient.permissionController.getGrantedPermissions()
                if (!granted.containsAll(requiredPermissions)) {
                    CoroutineScope(Dispatchers.Main).launch {
                        result.error("PERMISSION_DENIED", "Health Connect read permission not granted", null)
                    }
                    return@launch
                }

                val zoneId = ZoneId.systemDefault()
                val dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd")

                // Normalize to start of day in local timezone
                val normalizedStartInstant = Instant.ofEpochMilli(startTime)
                    .atZone(zoneId)
                    .toLocalDate()
                    .atStartOfDay(zoneId)
                    .toInstant()

                val request = AggregateGroupByDurationRequest(
                    metrics = setOf(DistanceRecord.DISTANCE_TOTAL),
                    timeRangeFilter = TimeRangeFilter.between(
                        normalizedStartInstant,
                        Instant.ofEpochMilli(endTime)
                    ),
                    timeRangeSlicer = Duration.ofDays(1)
                )

                val response = healthConnectClient.aggregateGroupByDuration(request)

                val results = mutableListOf<Map<String, Any>>()

                response.forEach { bucket ->
                    // bucket.startTime is Instant
                    val day: LocalDate = bucket.startTime.atZone(zoneId).toLocalDate()
                    val date = day.format(dateFormatter)

                    val totalMeters = bucket.result[DistanceRecord.DISTANCE_TOTAL]?.inMeters ?: 0.0
                    val kilometers = totalMeters / 1000.0

                    results.add(
                        mapOf(
                            "date" to date,
                            "total_kilometers" to kilometers
                        )
                    )
                }

                // Keep your old behavior: ensure today exists in list (optional).
                // With HC it *should* exist as 0 if there are no records in today's bucket,
                // but depending on implementation it can omit empty buckets - so we keep your logic.
                val todayDate = LocalDate.now(zoneId).format(dateFormatter)
                val hasToday = results.any { it["date"] == todayDate }

                if (!hasToday) {
                    val now = System.currentTimeMillis()
                    val startOfTodayInstant = LocalDate.now(zoneId)
                        .atStartOfDay(zoneId)
                        .toInstant()

                    // Reuse HC getKilometers (your refactored one)
                    getKilometers(
                        startOfTodayInstant.toEpochMilli(),
                        now,
                        object : MethodChannel.Result {
                            override fun success(todayKm: Any?) {
                                val km = (todayKm as? Double) ?: 0.0
                                results.add(
                                    mapOf(
                                        "date" to todayDate,
                                        "total_kilometers" to km
                                    )
                                )
                                result.success(results)
                            }

                            override fun error(code: String, message: String?, details: Any?) {
                                result.success(results)
                            }

                            override fun notImplemented() {
                                result.success(results)
                            }
                        }
                    )
                } else {
                    CoroutineScope(Dispatchers.Main).launch {
                        result.success(results)
                    }
                }
            } catch (e: Exception) {
                CoroutineScope(Dispatchers.Main).launch {
                    result.error("HC_ERROR", "Failed to read grouped distance: ${e.localizedMessage}", null)
                }
            }
        }
    }

//


    private fun ensureActivityPermission(result: MethodChannel.Result, onGranted: () -> Unit) {
        if (ContextCompat.checkSelfPermission(
                this,
                Manifest.permission.ACTIVITY_RECOGNITION
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            pendingActivityPermissionCall = result to onGranted
            ActivityCompat.requestPermissions(
                this,
                arrayOf(Manifest.permission.ACTIVITY_RECOGNITION),
                ACTIVITY_RECOGNITION_REQUEST_CODE
            )
        } else {
            onGranted()
        }
    }

//    private fun getKilometersGroupedByDay(
//        startTime: Long,
//        endTime: Long,
//        result: MethodChannel.Result
//    ) {
//        val account = GoogleSignIn.getLastSignedInAccount(this)
//        if (account == null) {
//            result.error("NO_ACCOUNT", "Google account not signed in", null)
//            return
//        }
//
//        // Normalize to start of day to avoid partial buckets when sync starts late at night
//        val normalizedStart = getStartOfDayMillis(startTime)
//
//        val readRequest = DataReadRequest.Builder()
//            .aggregate(DataType.TYPE_DISTANCE_DELTA)
//            .bucketByTime(1, TimeUnit.DAYS)
//            .setTimeRange(normalizedStart, endTime, TimeUnit.MILLISECONDS)
//            .build()
//
//        Fitness.getHistoryClient(this, account)
//            .readData(readRequest)
//            .addOnSuccessListener { response ->
//                val results = mutableListOf<Map<String, Any>>()
//
//                response.buckets.forEach { bucket ->
//                    var distanceForDay = 0.0
//                    val startMillis = bucket.getStartTime(TimeUnit.MILLISECONDS)
//
//                    bucket.dataSets.forEach { ds ->
//                        ds.dataPoints.forEach { dp ->
//                            if (dp.originalDataSource.device != null) {
//                                distanceForDay += dp.getValue(Field.FIELD_DISTANCE).asFloat()
//                            }
//                        }
//                    }
//
//                    val date = SimpleDateFormat("yyyy-MM-dd")
//                        .apply { timeZone = TimeZone.getDefault() }
//                        .format(startMillis)
//
//                    val kilometers = distanceForDay / 1000.0
//
//                    results.add(
//                        mapOf(
//                            "date" to date,
//                            "total_kilometers" to kilometers
//                        )
//                    )
//                }
//
//                val todayDate = SimpleDateFormat("yyyy-MM-dd")
//                    .apply { timeZone = TimeZone.getDefault() }
//                    .format(System.currentTimeMillis())
//
//                val hasToday = results.any { it["date"] == todayDate }
//
//                if (!hasToday) {
//                    val now = System.currentTimeMillis()
//                    val startOfToday = getStartOfDayMillis(now)
//
//                    getKilometers(startOfToday, now, object : MethodChannel.Result {
//                        override fun success(todayKm: Any?) {
//                            val kilometers = (todayKm as? Double) ?: 0.0
//                            results.add(
//                                mapOf(
//                                    "date" to todayDate,
//                                    "total_kilometers" to kilometers
//                                )
//                            )
//                            result.success(results)
//                        }
//
//                        override fun error(code: String, message: String?, details: Any?) {
//                            result.success(results)
//                        }
//
//                        override fun notImplemented() {
//                            result.success(results)
//                        }
//                    })
//                } else {
//                    result.success(results)
//                }
//            }
//            .addOnFailureListener { e ->
//                result.error("FITNESS_ERROR", "Failed to read grouped distance: ${e.localizedMessage}", null)
//            }
//    }

//    private fun getKilometers(
//        startTime: Long,
//        endTime: Long,
//        result: MethodChannel.Result
//    ) {
//        val account = GoogleSignIn.getLastSignedInAccount(this)
//        if (account == null) {
//            result.error("NO_ACCOUNT", "Google account not signed in", null)
//            return
//        }
//
//        val readRequest = DataReadRequest.Builder()
//            .aggregate(DataType.TYPE_DISTANCE_DELTA)
//            .bucketByTime(1, TimeUnit.DAYS)
//            .setTimeRange(startTime, endTime, TimeUnit.MILLISECONDS)
//            .build()
//
//        Fitness.getHistoryClient(this, account)
//            .readData(readRequest)
//            .addOnSuccessListener { response ->
//                var totalDistance = 0.0
//                response.buckets.forEach { bucket ->
//                    bucket.dataSets.forEach { ds ->
//                        ds.dataPoints.forEach { dp ->
//                            if (dp.originalDataSource.device != null) {
//                                totalDistance += dp.getValue(Field.FIELD_DISTANCE).asFloat()
//                            }
//                        }
//                    }
//                }
//                val kilometers = totalDistance / 1000.0
//                result.success(kilometers)
//            }
//            .addOnFailureListener { e ->
//                result.error("FITNESS_ERROR", "Failed to read distance: ${e.localizedMessage}", null)
//            }
//    }


    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == ACTIVITY_RECOGNITION_REQUEST_CODE) {
            val (result, onGranted) = pendingActivityPermissionCall ?: return
            pendingActivityPermissionCall = null
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                onGranted()
            } else {
                result.error("PERMISSION_DENIED", "Activity recognition permission denied", null)
            }
        }
    }

    private fun ensureSignedInThen(onSignedIn: () -> Unit) {
        signInIfNeeded(object : MethodChannel.Result {
            override fun success(o: Any?) = onSignedIn()
            override fun error(code: String, message: String?, details: Any?) {}
            override fun notImplemented() {}
        }) { onSignedIn() }
    }

    private fun ensureActivityPermissionThen(onGranted: () -> Unit) {
        ensureActivityPermission(object : MethodChannel.Result {
            override fun success(o: Any?) = onGranted()
            override fun error(code: String, message: String?, details: Any?) {}
            override fun notImplemented() {}
        }) { onGranted() }
    }

    private fun ensureFitPermissionThen(onGranted: () -> Unit) {
        withFitPermissions(object : MethodChannel.Result {
            override fun success(o: Any?) = onGranted()
            override fun error(code: String, message: String?, details: Any?) {}
            override fun notImplemented() {}
        }) { onGranted() }
    }

    private fun registerStepSensor() {
        if (stepListener != null) return

        val fitnessOptions = FitnessOptions.builder()
            .addDataType(DataType.TYPE_STEP_COUNT_DELTA, FitnessOptions.ACCESS_READ)
            .addDataType(DataType.TYPE_DISTANCE_DELTA, FitnessOptions.ACCESS_READ)
            .build()
        val account = GoogleSignIn.getAccountForExtension(this, fitnessOptions) ?: return

        // reset akumulatora
        distanceSinceLastEmit = 0.0
        lastEmitAt = System.currentTimeMillis()

        stepListener = OnDataPointListener { dp ->
            val deltaDistance = dp.getValue(Field.FIELD_DISTANCE).asFloat().toDouble()
            if (deltaDistance <= 0) return@OnDataPointListener

            distanceSinceLastEmit += deltaDistance

            val now = System.currentTimeMillis()
            val reachedDistance = distanceSinceLastEmit >= DIST_THRESHOLD_METERS
            val intervalOk = (now - lastEmitAt) >= MIN_EMIT_INTERVAL_MS
            val longSilence = (now - lastEmitAt) >= MAX_SILENCE_MS

            if ((reachedDistance && intervalOk) || longSilence) {
                val deltaKm = distanceSinceLastEmit / 1000.0

                // reset
                distanceSinceLastEmit = 0.0
                lastEmitAt = now

                mainHandler.post {
                    channel.invokeMethod("stepCountChanged", deltaKm)

                    // Also update cache for background updates
                    updateDistanceCache(deltaKm)
                }
            }
        }

        Fitness.getSensorsClient(this, account)
            .add(
                SensorRequest.Builder()
                    .setDataType(DataType.TYPE_DISTANCE_DELTA)
                    .setSamplingRate(3, TimeUnit.SECONDS)
                    .build(),
                stepListener!!
            )
            .addOnSuccessListener { Log.d("MainActivity", "Distance sensor listener registered") }
            .addOnFailureListener { e ->
                Log.e("MainActivity", "Failed to register distance sensor listener", e)
                stepListener = null
            }
    }

    private fun unregisterStepSensor() {
        val account = GoogleSignIn.getLastSignedInAccount(this) ?: return
        stepListener?.let {
            Fitness.getSensorsClient(this, account).remove(it)
            stepListener = null
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        unregisterStepSensor()
    }

    /**
     * Updates the cached distance for today in SharedPreferences.
     * This is used to keep track of kilometers in the background.
     */
    private fun updateDistanceCache(deltaKm: Double) {
        val prefs = getSharedPreferences("FlutterSharedPreferences", MODE_PRIVATE)
        val editor = prefs.edit()

        // Safely read the current value
        val currentKm = try {
            prefs.getFloat("flutter.bg_pending_today_km", 0f)
        } catch (e: ClassCastException) {
            editor.remove("flutter.bg_pending_today_km")
            editor.apply()
            0f
        }

        val newTotal = currentKm + deltaKm.toFloat()
        editor.putFloat("flutter.bg_pending_today_km", newTotal).apply()
    }
}