package com.example.layla

import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import android.os.Bundle
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {

    private val CHANNEL = "com.example.layla/tflite"  // Channel name to communicate with Flutter

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Initialize FlutterEngine manually if necessary
        val flutterEngine = flutterEngine ?: FlutterEngine(this)

        // Set up the method channel and the handler for the 'loadModel' method
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "loadModel") {
                // Call your model loading function here
                val modelPath = "assets/model.tflite"  // Path to your model
                val isModelLoaded = loadModel(modelPath)

                if (isModelLoaded) {
                    result.success("Model Loaded Successfully")
                } else {
                    result.error("LOAD_ERROR", "Failed to load model", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    // Example function to load your TFLite model
    private fun loadModel(modelPath: String): Boolean {
        // Implement model loading logic here using TensorFlow Lite
        // Return true if successful, false if it fails
        try {
            // Your model loading logic (e.g., using Interpreter in TensorFlow Lite)
            // Example: Interpreter(File(modelPath)) 
            return true
        } catch (e: Exception) {
            e.printStackTrace()
            return false
        }
    }
}
