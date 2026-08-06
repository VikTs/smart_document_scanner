package com.viktsukan.docscanner.share

import android.content.Context
import android.net.Uri
import android.util.Log
import java.io.File
import java.io.FileOutputStream

object ImageCacheManager {
    fun copyToCache(
        context: Context,
        uri: Uri,
    ): File? =
        try {
            val file =
                File(
                    context.cacheDir,
                    "DocScanner document.jpg",
                )

            context.contentResolver
                .openInputStream(uri)
                ?.use { input ->

                    FileOutputStream(file)
                        .use { output ->

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
