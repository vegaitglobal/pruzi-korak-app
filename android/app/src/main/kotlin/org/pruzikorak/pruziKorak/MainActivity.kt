package org.pruziikorak.pruziKorak

import android.content.Intent
import androidx.activity.result.ActivityResultLauncher
import androidx.health.connect.client.HealthConnectClient
import androidx.health.connect.client.permission.HealthPermission
import androidx.health.connect.client.PermissionController
import androidx.health.connect.client.records.DistanceRecord
import androidx.health.connect.client.request.AggregateGroupByDurationRequest
import androidx.health.connect.client.request.AggregateRequest
import androidx.health.connect.client.time.TimeRangeFilter
import androidx.health.connect.client.aggregate.AggregationResult
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.time.Duration
import java.time.Instant
import java.time.LocalDate
import java.time.ZoneId
import java.time.format.DateTimeFormatter

class MainActivity : FlutterFragmentActivity() {
    companion object {
        private const val CHANNEL_NAME = "org.pruziKorak.healthkit/callback"
        private const val HEALTH_CONNECT_PERMISSIONS_REQUEST_CODE = 1101
    }

    private lateinit var channel: MethodChannel

    private var pendingHealthConnectPermissionCall: Pair<MethodChannel.Result, () -> Unit>? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NAME)

        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "getKilometersGroupedByDay" -> {
                    val ts = call.arguments as? Double
                    if (ts == null) {
                        result.error("INVALID_ARGUMENT", "Expected timestamp", null)
                    } else {
                        val start = (ts * 1000).toLong()
                        val end = System.currentTimeMillis()
                        ensureHealthConnectPermissions(result) {
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

    private fun getKilometers(
        startTime: Long,
        endTime: Long,
        result: MethodChannel.Result
    ) {
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

    // Mark: Health Connect Permissions

    private fun ensureHealthConnectPermissions(
        result: MethodChannel.Result,
        onGranted: () -> Unit
    ) {
        if (!isHealthConnectAvailable()) {
            result.error("HC_NOT_AVAILABLE", "Health Connect is not available on this device", null)
            return
        }

        val client = HealthConnectClient.getOrCreate(this)

        CoroutineScope(Dispatchers.IO).launch {
            try {
                val granted = client.permissionController.getGrantedPermissions()

                if (granted.containsAll(hcRequiredPermissions)) {
                    withContext(Dispatchers.Main) { onGranted() }
                } else {
                    withContext(Dispatchers.Main) {
                        pendingHcCall = result to onGranted
                        hcPermissionLauncher.launch(hcRequiredPermissions)
                    }
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    result.error("HC_ERROR", "Failed to check/request permissions: ${e.localizedMessage}", null)
                }
            }
        }
    }


    private val hcRequiredPermissions = setOf(
        HealthPermission.getReadPermission(DistanceRecord::class),
    )

    private var pendingHcCall: Pair<MethodChannel.Result, () -> Unit>? = null

    private val hcPermissionLauncher: ActivityResultLauncher<Set<String>> by lazy {
        registerForActivityResult(
            PermissionController.createRequestPermissionResultContract()
        ) { granted: Set<String> ->
            val pending = pendingHcCall ?: return@registerForActivityResult
            val (result, onGranted) = pending
            pendingHcCall = null

            if (granted.containsAll(hcRequiredPermissions)) {
                onGranted()
            } else {
                result.error("PERMISSION_DENIED", "Health Connect permission denied", null)
            }
        }
    }

    private fun isHealthConnectAvailable(): Boolean {
        return when (HealthConnectClient.getSdkStatus(this)) {
            HealthConnectClient.SDK_AVAILABLE -> true
            HealthConnectClient.SDK_UNAVAILABLE -> false
            HealthConnectClient.SDK_UNAVAILABLE_PROVIDER_UPDATE_REQUIRED -> false
            else -> false
        }
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