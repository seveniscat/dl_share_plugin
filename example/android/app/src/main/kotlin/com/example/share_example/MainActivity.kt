package com.example.share_example

import android.os.Bundle
import android.os.PersistableBundle
import com.example.share.AppShare
import com.example.share.AppSharePlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        var mShareFlutterApi=AppShare.ShareFlutterApi(flutterEngine?.dartExecutor?.binaryMessenger)
        AppShare.ShareHostApi.setup(flutterEngine?.dartExecutor?.binaryMessenger,AppSharePlugin(this,mShareFlutterApi));

    }


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)

    }
}
