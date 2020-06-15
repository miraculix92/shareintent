package com.receivelink.shareintent

import android.content.Context
import android.content.Intent
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.*
import io.flutter.plugin.common.PluginRegistry.Registrar


/** ShareintentPlugin */
class GetShareIntentPlugin:
        MethodChannel.MethodCallHandler,
        FlutterPlugin,
        EventChannel.StreamHandler,
        PluginRegistry.NewIntentListener,
        ActivityAware {

  private var currentShare: String? = null
  private var methodChannel: MethodChannel? = null
  private var eventChannel: EventChannel? = null
  private var eventSink: EventChannel.EventSink? = null

  fun registerWith(registrar: Registrar) {
    val plugin = GetShareIntentPlugin()
    plugin.setupChannels(registrar.messenger(), registrar.context())
  }

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    setupChannels(binding.binaryMessenger, binding.applicationContext)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    teardownChannels()
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    binding.addOnNewIntentListener(this)
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    onAttachedToActivity(binding)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity()
  }

  override fun onDetachedFromActivity() {
    teardownChannels()
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    if (call.method == "shareIntent" && currentShare != null) {
      result.success(currentShare)
    }
    else {result.error("No Intent received.", "", "");}
  }

  override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
    this.eventSink = events
  }

  override fun onCancel(arguments: Any?) {
    eventSink = null
  }

  override fun onNewIntent(intent: Intent?): Boolean {
    handleIntent(intent)
    return false
  }

  private fun handleIntent(intent: Intent?) {
    currentShare = intent!!.getStringExtra(Intent.EXTRA_TEXT)
    eventSink!!.success(currentShare)
  }

  private fun setupChannels(messenger : BinaryMessenger, context : Context) {
    methodChannel = MethodChannel(messenger, "plugins.flutter.io/shareintent")
    eventChannel = EventChannel(messenger, "plugins.flutter.io/shareintent_status")
    methodChannel!!.setMethodCallHandler(this)
    eventChannel!!.setStreamHandler(this)
  }

  private fun teardownChannels() {
    methodChannel!!.setMethodCallHandler(null)
    eventChannel!!.setStreamHandler(null)
    methodChannel = null
    eventChannel = null
  }
}
