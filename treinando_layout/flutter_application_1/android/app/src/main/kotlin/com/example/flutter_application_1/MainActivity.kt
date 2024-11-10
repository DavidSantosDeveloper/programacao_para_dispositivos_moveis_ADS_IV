package com.example.flutter_application_1

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.gallery/channel"
    private val VERSION_CHANNEL = "com.example.app/version"
    private val PICK_IMAGE = 100
    private var resultPath: MethodChannel.Result? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Canal para abrir a galeria
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "openGallery") {
                resultPath = result
                openGallery()
            } else {
                result.notImplemented()
            }
        }

        // Canal para verificar a versão do Android
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, VERSION_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getAndroidVersion") {
                val androidVersion = Build.VERSION.SDK_INT
                result.success(androidVersion)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun openGallery() {
        val intent = Intent(Intent.ACTION_PICK)
        intent.type = "image/*"
        startActivityForResult(intent, PICK_IMAGE)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == PICK_IMAGE && resultCode == Activity.RESULT_OK) {
            val imageUri: Uri? = data?.data
            val path = getRealPathFromURI(imageUri)
            resultPath?.success(path)
        } else {
            resultPath?.success(null)
        }
    }

    private fun getRealPathFromURI(uri: Uri?): String? {
        uri?.let {
            val projection = arrayOf(android.provider.MediaStore.Images.Media.DATA)
            val cursor = contentResolver.query(it, projection, null, null, null)
            cursor?.use {
                val columnIndex = cursor.getColumnIndexOrThrow(android.provider.MediaStore.Images.Media.DATA)
                cursor.moveToFirst()
                return cursor.getString(columnIndex)
            }
        }
        return null
    }
}