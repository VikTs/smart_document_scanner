package com.viktsukan.docscanner.share

import android.content.Context
import android.content.Intent
import android.net.Uri

class ShareImageHandler(
    private val context: Context,
) {
    private var sharedImagePath: String? = null

    fun handleIntent(intent: Intent?) {
        if (intent?.action != Intent.ACTION_SEND) {
            return
        }

        val uri =
            intent.getParcelableExtra<Uri>(
                Intent.EXTRA_STREAM,
            )

        if (uri != null) {
            val file =
                ImageCacheManager.copyToCache(
                    context,
                    uri,
                )
            sharedImagePath =
                file?.absolutePath
        }
    }

    fun getSharedImage(): String? {
        val path = sharedImagePath
        sharedImagePath = null
        return path
    }
}