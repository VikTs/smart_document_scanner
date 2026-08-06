package com.viktsukan.docscanner

import android.content.Intent
import android.os.Bundle
import com.viktsukan.docscanner.channels.QuickScanChannel
import com.viktsukan.docscanner.channels.SharedImageChannel
import com.viktsukan.docscanner.channels.SimCountryChannel
import com.viktsukan.docscanner.share.ShareImageHandler
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    private val shareImageHandler by lazy {
        ShareImageHandler(this)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        SimCountryChannel.register(
            flutterEngine,
            this,
        )

        SharedImageChannel.register(
            flutterEngine,
            shareImageHandler,
        )

        QuickScanChannel.register(
            flutterEngine,
        )
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        shareImageHandler.handleIntent(intent)
        QuickScanChannel.handleIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)

        shareImageHandler.handleIntent(intent)
        QuickScanChannel.handleIntent(intent)
    }
}