package com.fm.nativetextfield

import android.annotation.SuppressLint
import android.content.ClipData
import android.content.Context
import android.view.View
import android.widget.EditText
import androidx.core.view.ContentInfoCompat
import androidx.core.view.OnReceiveContentListener
import androidx.core.view.ViewCompat
import io.flutter.Log
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import java.io.InputStream

class ChatInputEditText(context: Context, methodChannel: MethodChannel) : PlatformView {
    private val editText = EditText(context).apply {
        ViewCompat.setOnReceiveContentListener(
            this,
            ChatInputReceiver.MIME_TYPES,
            ChatInputReceiver(methodChannel),
        )
        hint = "Enter text here"
        instance = this@ChatInputEditText
    }

    override fun getView() = editText

    override fun dispose() {
        instance = null
    }

    companion object {
        @SuppressLint("StaticFieldLeak")
        var instance: ChatInputEditText? = null
        fun getInputText(): String {
            return instance?.editText?.text.toString()
        }

        fun clearInputText() {
            instance?.editText?.setText("")
        }

        fun setHintText(text: String?) {
            instance?.editText?.hint = text
        }

        fun setInputText(text: String?) {
            instance?.editText?.setText(text)
        }
    }
}

class CustomEditTextFactory(private val methodChannel: MethodChannel) :
    PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        return ChatInputEditText(context, methodChannel)
    }
}

class ChatInputReceiver(private val methodChannel: MethodChannel) : OnReceiveContentListener {

    override fun onReceiveContent(view: View, contentInfo: ContentInfoCompat): ContentInfoCompat? {
        val split = contentInfo.partition { item: ClipData.Item -> item.uri != null }
        val uriContent = split.first
        val remaining = split.second
        if (uriContent != null && uriContent.clip.itemCount > 0) {
            val uri = uriContent.clip.getItemAt(0).uri
            try {
                view.context.contentResolver.openInputStream(uri)?.use { inputStream ->
                    val bytes = inputStream.readBytes()
                    val base64String = bytes.let { byteArray ->
                        android.util.Base64.encodeToString(
                            byteArray,
                            android.util.Base64.NO_WRAP
                        )
                    }
                    Log.d("ChatInputEditText", "Pasted image handled")
                    methodChannel.invokeMethod("pasteImage", base64String)
                }
            } catch (e: Throwable) {
                Log.e("ChatInputEditText", "Failed to handle pasted image")
            }
        }
        return remaining
    }

    companion object {
        val MIME_TYPES = arrayOf("image/jpeg", "image/jpg", "image/png")
    }
}