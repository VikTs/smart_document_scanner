package com.viktsukan.docscanner

import android.os.Bundle
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
    }

    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)

        shareImageHandler.handleIntent(intent)
    }
}
