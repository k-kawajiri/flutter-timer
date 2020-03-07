package com.kawanoji.flutter_timer

import android.content.Context
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import androidx.annotation.NonNull
import androidx.core.content.ContextCompat.getSystemService
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    companion object {
        private const val CHANNEL = "flutter/vibration"
    }

    private val TIMING_AMPLITUDE_PAIR = Pair(longArrayOf(1000, 500), intArrayOf(android.os.VibrationEffect.DEFAULT_AMPLITUDE, 0))
    private val MILLISECONDS_AMPLITUDE_PAIR = Pair(100L, VibrationEffect.DEFAULT_AMPLITUDE)
    private val vibrator by lazy {
        getSystemService(context, Vibrator::class.java)
                ?: throw IllegalStateException()
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
                .setMethodCallHandler { methodCall, result ->
                    when (methodCall.method) {
                        // 周期的に振動させる
                        "vibrateWave" -> vibrateWave()
                        // 一度だけ振動させる
                        "vibrateOneShot" -> vibrateOneShot()
                        // 振動を止める
                        "cancel" -> vibrator.cancel()
                    }
                    result.success("success")
                    //result.error("code1", "error", "details");
                }
    }

    private fun vibrateWave() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val effect = VibrationEffect.createWaveform(TIMING_AMPLITUDE_PAIR.first, TIMING_AMPLITUDE_PAIR.second, 0)
            vibrator.vibrate(effect)
        } else {
            vibrator.vibrate(TIMING_AMPLITUDE_PAIR.first, 0)
        }
    }

    private fun vibrateOneShot() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val effect = VibrationEffect.createOneShot(MILLISECONDS_AMPLITUDE_PAIR.first, MILLISECONDS_AMPLITUDE_PAIR.second)
            vibrator.vibrate(effect)
        } else {
            vibrator.vibrate(MILLISECONDS_AMPLITUDE_PAIR.first)
        }
    }

}
