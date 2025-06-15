package org.pruzikorak.pruziKorak

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
import com.google.android.gms.fitness.request.DataReadRequest
import java.util.TimeZone
import java.util.concurrent.TimeUnit

class MainActivity : FlutterActivity() {
    companion object {
        private const val SIGN_IN_REQUEST_CODE = 9001
        private const val ACTIVITY_RECOGNITION_REQUEST_CODE = 1002
        private const val GOOGLE_FIT_PERMISSIONS_REQUEST_CODE = 1001
    }

    private val CHANNEL = "org.pruziKorak.healthkit/callback"

    private var pendingStepCall: Pair<MethodChannel.Result, () -> Unit>? = null
    private var pendingActivityPermissionCall: Pair<MethodChannel.Result, () -> Unit>? = null
    private var pendingFitPermissionCall: Pair<MethodChannel.Result, () -> Unit>? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getStepsToday" -> {
                        val now = System.currentTimeMillis()
                        val startOfDay = getStartOfDayMillis(now)

                        signInIfNeeded(result) {
                            ensureActivityPermission(result) {
                                withFitPermissions(result) {
                                    getStepCount(startOfDay, now, result)
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
                            val src = dp.originalDataSource.appPackageName ?: ""
                            val stream = dp.originalDataSource.streamName ?: ""
                            val isManual = src.contains("user_input", true)
                                    || stream.contains("user_input", true)
                                    || src.contains("com.google.android.apps.fitness")

                            if (!isManual) {
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

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        Log.d("MainActivity", "Request code: $requestCode, Result code: $resultCode")

        when (requestCode) {
            SIGN_IN_REQUEST_CODE -> {
                val (result, onSignedIn) = pendingStepCall ?: return
                pendingStepCall = null

                val task = GoogleSignIn.getSignedInAccountFromIntent(data)
                try {
                    val account = task.result
                    Log.d("MainActivity", "Signed in as: ${account.email}")
                    onSignedIn()
                } catch (e: Exception) {
                    Log.e("MainActivity", "Sign-in exception", e)
                    result.error("SIGN_IN_FAILED", "Google sign-in failed: ${e.message}", null)
                }
            }

            GOOGLE_FIT_PERMISSIONS_REQUEST_CODE -> {
                val (result, onGranted) = pendingFitPermissionCall ?: return
                pendingFitPermissionCall = null
                if (resultCode == Activity.RESULT_OK) {
                    Log.d("MainActivity", "Google Fit permission granted")
                    onGranted()
                } else {
                    Log.e("MainActivity", "Google Fit permission denied")
                    result.error("PERMISSION_DENIED", "User denied Google Fit permission", null)
                }
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
                result.error(
                    "PERMISSION_DENIED",
                    "Activity recognition permission denied",
                    null
                )
            }
        }
    }

    private fun getStartOfDayMillis(now: Long): Long {
        val dayMillis = 24 * 60 * 60 * 1000L
        val tzOffset = TimeZone.getDefault().getOffset(now)
        return (now + tzOffset) / dayMillis * dayMillis - tzOffset
    }
}