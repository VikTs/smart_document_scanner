package com.viktsukan.docscanner

import android.telephony.TelephonyManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "sim_country"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
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
    }
}