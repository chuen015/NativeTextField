package com.fm.nativetextfield

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

object ChatInputChannel {

    private const val chatInputChannel = "com.fm.nativeinput/chat_input"
    private const val viewTypeId = "ChatInputEditText"

    private val methodCallHandler =
        MethodChannel.MethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
            when (call.method) {
                "getInputText" -> {
                    val text = ChatInputEditText.getInputText()
                    result.success(text)
                }

                "clearInputText" -> {
                    ChatInputEditText.clearInputText()
                    result.success(null)
                }

                "setHintText" -> {
                    val text = call.argument<String>("text")
                    ChatInputEditText.setHintText(text)
                    result.success(null)
                }

                "setInputText" -> {
                    val text = call.argument<String>("text")
                    ChatInputEditText.setInputText(text)
                    result.success(null)
                }

                else -> result.notImplemented()
            }
        }

    fun registerChannel(flutterEngine: FlutterEngine) {
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            chatInputChannel,
        ).apply {
            setMethodCallHandler(methodCallHandler)
            flutterEngine.platformViewsController.registry.registerViewFactory(
                viewTypeId,
                CustomEditTextFactory(methodChannel = this)
            )
        }
    }
}
