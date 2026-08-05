package com.viktsukan.docscanner

import android.content.Intent
import android.net.Uri
import android.telephony.TelephonyManager
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream

class MainActivity : FlutterActivity() {
    private val CHANNEL = "sim_country"
    private val SHARE_CHANNEL = "shared_image"

    private var sharedImagePath: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL,
        ).setMethodCallHandler { call, result ->
            if (call.method == "getSimCountry") {
                val telephonyManager =
                    getSystemService(TELEPHONY_SERVICE) as TelephonyManager

                val country = telephonyManager.simCountryIso?.uppercase()

                result.success(country)
            } else {
                result.notImplemented()
            }
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            SHARE_CHANNEL,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getSharedImage" -> {
                    val path = sharedImagePath
                    sharedImagePath = null
                    result.success(path)
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)
        handleShareIntent(intent)
    }

    private fun handleShareIntent(intent: Intent?) {
        if (intent?.action == Intent.ACTION_SEND) {
            val uri =
                intent.getParcelableExtra<Uri>(
                    Intent.EXTRA_STREAM,
                )

            if (uri != null) {
                val file = copyUriToCache(uri)
                sharedImagePath = file?.absolutePath
            }
        }
    }

    private fun copyUriToCache(uri: Uri): File? =
        try {
            val inputStream =
                contentResolver.openInputStream(uri)

            val file =
                File(
                    cacheDir,
                    "Shared document.jpg",
                )

            val outputStream =
                FileOutputStream(file)

            inputStream?.use { input ->
                outputStream.use { output ->
                    input.copyTo(output)
                }
            }

            file
        } catch (e: Exception) {
            Log.e(
                "DocScanner",
                "Copy error: ${e.message}",
            )
            null
        }
}
