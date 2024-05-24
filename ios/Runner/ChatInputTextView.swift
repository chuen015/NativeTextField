//
//  ChatInputTextView.swift
//  Runner
//
//  Created by Jason Lee on 2024/5/23.
//

import Foundation
import OSLog

class ChatInputTextViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    private var methodChannel: FlutterMethodChannel

    init(messenger: FlutterBinaryMessenger, methodChannel: FlutterMethodChannel) {
        self.messenger = messenger
        self.methodChannel = methodChannel
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return ChatInputTextView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger,
            methodChannel: methodChannel
        )
    }
}

class ChatInputTextView: NSObject, FlutterPlatformView {
    private var textView: ChatInputTextViewImpl

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?,
        methodChannel: FlutterMethodChannel
    ) {
        
        self.textView = ChatInputTextViewImpl(
            frame: frame, textContainer: nil,
            methodChannel: methodChannel
        )
        // set up UITextView appearance
        self.textView.font = UIFont.systemFont(ofSize: 16)
        self.textView.isEditable = true
        
        super.init()
        ChatInputTextView.sharedInstance = self
    }

    static var sharedInstance: ChatInputTextView?

    static func getInputText() -> String {
        return sharedInstance?.textView.text ?? ""
    }

    static func clearInputText() {
        sharedInstance?.textView.text = ""
    }
    
    static func setHintText(_ text: String) {
        // TODO
    }

    static func setInputText(_ text: String) {
        sharedInstance?.textView.text = text
    }

    func view() -> UIView {
        return textView
    }
}

class ChatInputTextViewImpl: UITextView {
    private let logger = Logger()
    private var methodChannel: FlutterMethodChannel?
    
    init(
        frame: CGRect,
        textContainer: NSTextContainer?,
        methodChannel: FlutterMethodChannel
    ) {
        self.methodChannel = methodChannel
        super.init(frame: frame, textContainer: textContainer)
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // Override to enable paste action
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(paste(_:)) {
            // Check if the pasteboard contains an image
            if UIPasteboard.general.image != nil {
                return true
            }
        }
        return super.canPerformAction(action, withSender: sender)
    }

    override func paste(_ sender: Any?) {
        super.paste(sender)
        let pasteboard = UIPasteboard.general
        
        if let image = pasteboard.image, let imageData = image.pngData() {
            let size = pasteboard.image!.size
            logger.debug("Pasted image = \(Int(size.width)) * \(Int(size.height))")
            let base64String = imageData.base64EncodedString()
            methodChannel?.invokeMethod("pasteImage", arguments: base64String)
            logger.debug("Pasted image handled")
        }
    }
}
