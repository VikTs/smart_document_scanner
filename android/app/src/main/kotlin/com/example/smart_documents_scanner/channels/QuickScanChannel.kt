package com.viktsukan.docscanner.channels

import android.content.Intent
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

object QuickScanChannel {
    private const val CHANNEL = "quick_scan"
    private const val QUICK_SCAN_ACTION =
        "com.viktsukan.docscanner.QUICK_SCAN"

    private var shouldStartQuickScan = false

    fun handleIntent(intent: Intent?) {
        shouldStartQuickScan =
            intent?.action == QUICK_SCAN_ACTION
    }

    fun register(flutterEngine: FlutterEngine) {
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "shouldStartQuickScan" -> {
                    result.success(shouldStartQuickScan)
                    shouldStartQuickScan = false
                }
                else -> result.notImplemented()
            }
        }
    }
}