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
import java.text.SimpleDateFormat
import java.util.TimeZone
import java.util.concurrent.TimeUnit

class MainActivity : FlutterActivity() {
    companion object {
        private const val CHANNEL_NAME = "org.pruziKorak.healthkit/callback"
        private const val SIGN_IN_REQUEST_CODE = 9001
        private const val ACTIVITY_RECOGNITION_REQUEST_CODE = 1002
        private const val GOOGLE_FIT_PERMISSIONS_REQUEST_CODE = 1001

        private const val EVENTS_NAME  = "org.pruziKorak.healthkit/step_events"

        private const val METERS_PER_STEP = 1000.0 / 1300.0    // ~0.769m po koraku (1300 steps = 1km)
        private const val DIST_THRESHOLD_METERS = 5.0        // emituje tek kad pređeš 5m
        private const val MIN_EMIT_INTERVAL_MS = 30_000L       // minimalni razmak između emitovanja (anti-spam)
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
                "getStepsGroupedByDay" -> {
                    val ts = call.arguments as? Double
                    if (ts == null) {
                        result.error("INVALID_ARGUMENT", "Expected timestamp", null)
                    } else {
                        val start = (ts * 1000).toLong()
                        val end = System.currentTimeMillis()
                        signInIfNeeded(result) {
                            ensureActivityPermission(result) {
                                withFitPermissions(result) {
                                    getStepsGroupedByDay(start, end, result)
                                }
                            }
                        }
                    }
                }

                "getTodayStepsSinceLastSync" -> {
                    val ts = call.arguments as? Double
                    if (ts == null) {
                        result.error("INVALID_ARGUMENT", "Expected timestamp", null)
                    } else {
                        val start = (ts * 1000).toLong()
                        val now = System.currentTimeMillis()
                        signInIfNeeded(result) {
                            ensureActivityPermission(result) {
                                withFitPermissions(result) {
                                    getStepCount(start, now, result)
                                }
                            }
                        }
                    }
                }

                "getStepsFromCampaignStart" -> {
                    val ts = call.arguments as? Double
                    if (ts == null) {
                        result.error("INVALID_ARGUMENT", "Expected timestamp", null)
                    } else {
                        val start = (ts * 1000).toLong()
                        val now = System.currentTimeMillis()
                        signInIfNeeded(result) {
                            ensureActivityPermission(result) {
                                withFitPermissions(result) {
                                    getStepCount(start, now, result)
                                }
                            }
                        }
                    }
                }

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
                        signInIfNeeded(result) {
                            ensureActivityPermission(result) {
                                withFitPermissions(result) {
                                    getKilometersGroupedByDay(start, end, result)
                                }
                            }
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
                        signInIfNeeded(result) {
                            ensureActivityPermission(result) {
                                withFitPermissions(result) {
                                    getKilometers(start, now, result)
                                }
                            }
                        }
                    }
                }

                "getKilometersFromCampaignStart" -> {
                    val ts = call.arguments as? Double
                    if (ts == null) {
                        result.error("INVALID_ARGUMENT", "Expected timestamp", null)
                    } else {
                        val start = (ts * 1000).toLong()
                        val now = System.currentTimeMillis()
                        signInIfNeeded(result) {
                            ensureActivityPermission(result) {
                                withFitPermissions(result) {
                                    getKilometers(start, now, result)
                                }
                            }
                        }
                    }
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun signInIfNeeded(result: MethodChannel.Result, onSignedIn: () -> Unit) {
        val acct = GoogleSignIn.getLastSignedInAccount(this)
        if (acct == null) {
            val gso = GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN)
                .requestEmail()
                .build()
            val client = GoogleSignIn.getClient(this, gso)
            pendingStepCall = result to onSignedIn
            startActivityForResult(client.signInIntent, SIGN_IN_REQUEST_CODE)
        } else {
            onSignedIn()
        }
    }

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

    private fun withFitPermissions(result: MethodChannel.Result, onGranted: () -> Unit) {
        val fitnessOptions = FitnessOptions.builder()
            .addDataType(DataType.TYPE_STEP_COUNT_DELTA, FitnessOptions.ACCESS_READ)
            .addDataType(DataType.TYPE_DISTANCE_DELTA, FitnessOptions.ACCESS_READ)
            .build()
        val account = GoogleSignIn.getAccountForExtension(this, fitnessOptions)
        if (GoogleSignIn.hasPermissions(account, fitnessOptions)) {
            onGranted()
        } else {
            pendingFitPermissionCall = result to onGranted
            GoogleSignIn.requestPermissions(
                this,
                GOOGLE_FIT_PERMISSIONS_REQUEST_CODE,
                account,
                fitnessOptions
            )
        }
    }

    private fun getStepsGroupedByDay(
        startTime: Long,
        endTime: Long,
        result: MethodChannel.Result
    ) {
        val account = GoogleSignIn.getLastSignedInAccount(this)
        if (account == null) {
            result.error("NO_ACCOUNT", "Google account not signed in", null)
            return
        }

        val readRequest = DataReadRequest.Builder()
            .aggregate(DataType.TYPE_STEP_COUNT_DELTA)
            .bucketByTime(1, TimeUnit.DAYS)
            .setTimeRange(startTime, endTime, TimeUnit.MILLISECONDS)
            .build()

        Fitness.getHistoryClient(this, account)
            .readData(readRequest)
            .addOnSuccessListener { response ->
                val results = mutableListOf<Map<String, Any>>()

                response.buckets.forEach { bucket ->
                    var stepsForDay = 0
                    val startMillis = bucket.getStartTime(TimeUnit.MILLISECONDS)

                    bucket.dataSets.forEach { ds ->
                        ds.dataPoints.forEach { dp ->
                            if (dp.originalDataSource.device != null) {
                                stepsForDay += dp.getValue(Field.FIELD_STEPS).asInt()
                            }
                        }
                    }

                    val date = SimpleDateFormat("yyyy-MM-dd")
                        .apply { timeZone = TimeZone.getDefault() }
                        .format(startMillis)

                    val kilometers = stepsForDay / 1300.0

                    results.add(
                        mapOf(
                            "date" to date,
                            "total_kilometers" to kilometers
                        )
                    )
                }

                val todayDate = SimpleDateFormat("yyyy-MM-dd")
                    .apply { timeZone = TimeZone.getDefault() }
                    .format(System.currentTimeMillis())

                val hasToday = results.any { it["date"] == todayDate }

                if (!hasToday) {
                    val now = System.currentTimeMillis()
                    val startOfToday = getStartOfDayMillis(now)

                    getStepCount(startOfToday, now, object : MethodChannel.Result {
                        override fun success(todaySteps: Any?) {
                            val steps = (todaySteps as? Double) ?: 0.0
                            val kilometers = steps / 1300.0
                            results.add(
                                mapOf(
                                    "date" to todayDate,
                                    "total_kilometers" to kilometers
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
                    })
                } else {
                    result.success(results)
                }
            }
            .addOnFailureListener { e ->
                result.error("FITNESS_ERROR", "Failed to read grouped steps: ${e.localizedMessage}", null)
            }
    }

    private fun getStepCount(
        startTime: Long,
        endTime: Long,
        result: MethodChannel.Result
    ) {
        val account = GoogleSignIn.getLastSignedInAccount(this)
        if (account == null) {
            result.error("NO_ACCOUNT", "Google account not signed in", null)
            return
        }

        val readRequest = DataReadRequest.Builder()
            .aggregate(DataType.TYPE_STEP_COUNT_DELTA)
            .bucketByTime(1, TimeUnit.DAYS)
            .setTimeRange(startTime, endTime, TimeUnit.MILLISECONDS)
            .build()

        Fitness.getHistoryClient(this, account)
            .readData(readRequest)
            .addOnSuccessListener { response ->
                var totalSteps = 0
                response.buckets.forEach { bucket ->
                    bucket.dataSets.forEach { ds ->
                        ds.dataPoints.forEach { dp ->
                            if (dp.originalDataSource.device != null) {
                                totalSteps += dp.getValue(Field.FIELD_STEPS).asInt()
                            }
                        }
                    }
                }
                result.success(totalSteps.toDouble())
            }
            .addOnFailureListener { e ->
                result.error("FITNESS_ERROR", "Failed to read steps: ${e.localizedMessage}", null)
            }
    }

    private fun getKilometersGroupedByDay(
        startTime: Long,
        endTime: Long,
        result: MethodChannel.Result
    ) {
        val account = GoogleSignIn.getLastSignedInAccount(this)
        if (account == null) {
            result.error("NO_ACCOUNT", "Google account not signed in", null)
            return
        }

        val readRequest = DataReadRequest.Builder()
            .aggregate(DataType.TYPE_DISTANCE_DELTA)
            .bucketByTime(1, TimeUnit.DAYS)
            .setTimeRange(startTime, endTime, TimeUnit.MILLISECONDS)
            .build()

        Fitness.getHistoryClient(this, account)
            .readData(readRequest)
            .addOnSuccessListener { response ->
                val results = mutableListOf<Map<String, Any>>()

                response.buckets.forEach { bucket ->
                    var distanceForDay = 0.0
                    val startMillis = bucket.getStartTime(TimeUnit.MILLISECONDS)

                    bucket.dataSets.forEach { ds ->
                        ds.dataPoints.forEach { dp ->
                            if (dp.originalDataSource.device != null) {
                                distanceForDay += dp.getValue(Field.FIELD_DISTANCE).asFloat()
                            }
                        }
                    }

                    val date = SimpleDateFormat("yyyy-MM-dd")
                        .apply { timeZone = TimeZone.getDefault() }
                        .format(startMillis)

                    val kilometers = distanceForDay / 1000.0

                    results.add(
                        mapOf(
                            "date" to date,
                            "total_kilometers" to kilometers
                        )
                    )
                }

                val todayDate = SimpleDateFormat("yyyy-MM-dd")
                    .apply { timeZone = TimeZone.getDefault() }
                    .format(System.currentTimeMillis())

                val hasToday = results.any { it["date"] == todayDate }

                if (!hasToday) {
                    val now = System.currentTimeMillis()
                    val startOfToday = getStartOfDayMillis(now)

                    getKilometers(startOfToday, now, object : MethodChannel.Result {
                        override fun success(todayKm: Any?) {
                            val kilometers = (todayKm as? Double) ?: 0.0
                            results.add(
                                mapOf(
                                    "date" to todayDate,
                                    "total_kilometers" to kilometers
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
                    })
                } else {
                    result.success(results)
                }
            }
            .addOnFailureListener { e ->
                result.error("FITNESS_ERROR", "Failed to read grouped distance: ${e.localizedMessage}", null)
            }
    }

    private fun getKilometers(
        startTime: Long,
        endTime: Long,
        result: MethodChannel.Result
    ) {
        val account = GoogleSignIn.getLastSignedInAccount(this)
        if (account == null) {
            result.error("NO_ACCOUNT", "Google account not signed in", null)
            return
        }

        val readRequest = DataReadRequest.Builder()
            .aggregate(DataType.TYPE_DISTANCE_DELTA)
            .bucketByTime(1, TimeUnit.DAYS)
            .setTimeRange(startTime, endTime, TimeUnit.MILLISECONDS)
            .build()

        Fitness.getHistoryClient(this, account)
            .readData(readRequest)
            .addOnSuccessListener { response ->
                var totalDistance = 0.0
                response.buckets.forEach { bucket ->
                    bucket.dataSets.forEach { ds ->
                        ds.dataPoints.forEach { dp ->
                            if (dp.originalDataSource.device != null) {
                                totalDistance += dp.getValue(Field.FIELD_DISTANCE).asFloat()
                            }
                        }
                    }
                }
                val kilometers = totalDistance / 1000.0
                result.success(kilometers)
            }
            .addOnFailureListener { e ->
                result.error("FITNESS_ERROR", "Failed to read distance: ${e.localizedMessage}", null)
            }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        when (requestCode) {
            SIGN_IN_REQUEST_CODE -> {
                val (result, onSignedIn) = pendingStepCall ?: return
                pendingStepCall = null
                val task = GoogleSignIn.getSignedInAccountFromIntent(data)
                try {
                    task.result
                    onSignedIn()
                } catch (e: Exception) {
                    result.error("SIGN_IN_FAILED", "Google sign-in failed: ${e.message}", null)
                }
            }
            GOOGLE_FIT_PERMISSIONS_REQUEST_CODE -> {
                val (result, onGranted) = pendingFitPermissionCall ?: return
                pendingFitPermissionCall = null
                if (resultCode == Activity.RESULT_OK) onGranted()
                else result.error("PERMISSION_DENIED", "Google Fit permission denied", null)
            }
        }
    }

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

    private fun getStartOfDayMillis(now: Long): Long {
        val dayMillis = 24 * 60 * 60 * 1000L
        val tzOffset = TimeZone.getDefault().getOffset(now)
        return (now + tzOffset) / dayMillis * dayMillis - tzOffset
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