package com.viktsukan.docscanner.channels

import android.content.Context
import android.telephony.TelephonyManager
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

object SimCountryChannel {
    private const val CHANNEL = "sim_country"

    fun register(
        flutterEngine: FlutterEngine,
        context: Context,
    ) {
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getSimCountry" -> {
                    val telephonyManager =
                        context.getSystemService(
                            Context.TELEPHONY_SERVICE
                        ) as TelephonyManager

                    result.success(
                        telephonyManager.simCountryIso
                            ?.uppercase()
                    )
                }
                else -> result.notImplemented()
            }
        }
    }
}