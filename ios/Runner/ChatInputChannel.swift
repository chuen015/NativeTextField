//
//  ChatInputChannel.swift
//  Runner
//
//  Created by Jason Lee on 2024/5/23.
//

import Foundation

class ChatInputChannel {
    
    private static let chatInputChannel = "com.fm.nativeinput/chat_input"
    private static let viewTypeId = "ChatInputTextView"
    
    static func handleMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getInputText":
            let text = ChatInputTextView.getInputText()
            result(text)
            
        case "clearInputText":
            ChatInputTextView.clearInputText()
            result(nil)
            
        case "setHintText":
            if let args = call.arguments as? [String: Any],
               let text = args["text"] as? String {
                ChatInputTextView.setHintText(text)
                result(nil)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Text argument is missing", details: nil))
            }
            
        case "setInputText":
            if let args = call.arguments as? [String: Any],
               let text = args["text"] as? String {
                ChatInputTextView.setInputText(text)
                result(nil)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Text argument is missing", details: nil))
            }
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    static func registerChannel(appDelegate: AppDelegate, messenger: FlutterBinaryMessenger) {
        let methodChannel = FlutterMethodChannel(
            name: chatInputChannel,
            binaryMessenger: messenger)
        // set the method call handler
        methodChannel.setMethodCallHandler(ChatInputChannel.handleMethodCall)
        let factory = ChatInputTextViewFactory(messenger: messenger, methodChannel: methodChannel)
        appDelegate.registrar(forPlugin: viewTypeId)?.register(factory, withId: viewTypeId)
    }
}
