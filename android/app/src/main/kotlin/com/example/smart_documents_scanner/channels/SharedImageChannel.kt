package com.viktsukan.docscanner.channels

import com.viktsukan.docscanner.share.ShareImageHandler
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

object SharedImageChannel {
    private const val CHANNEL = "shared_image"

    fun register(
        flutterEngine: FlutterEngine,
        handler: ShareImageHandler,
    ) {
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getSharedImage" -> {
                    result.success(
                        handler.getSharedImage()
                    )
                }
                else -> result.notImplemented()
            }
        }
    }
}