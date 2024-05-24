import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const HomePageWidget(),
    );
  }
}

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget>
    with WidgetsBindingObserver {
  static const chatInputChannel =
      MethodChannel('com.fm.nativeinput/chat_input');

  @override
  void initState() {
    super.initState();
    chatInputChannel.setMethodCallHandler(handleMethodCall);
  }

  String _sentText = "";

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'getInputText':
        final String result =
            await chatInputChannel.invokeMethod('getInputText');
        return result;
      case 'clearInputText':
        await chatInputChannel.invokeMethod('clearInputText');
        break;
      case 'setHintText':
        await chatInputChannel
            .invokeMethod('setHintText', {'text': call.arguments as String});
        break;
      case 'pasteImage':
        final String base64String = call.arguments;
        Uint8List data = base64Decode(base64String);
        var size = data.lengthInBytes;
        sendMessage("Paste image size = $size");
        break;
      default:
        print("Unknown method called: ${call.method}");
    }
  }

  void sendMessage(String text) {
    setState(() {
      _sentText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Center(
              child: Text(_sentText, style: const TextStyle(fontSize: 24.0)),
            ),
          ),
          const Divider(height: 1, color: Colors.blue),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 64.0,
            child: Row(
              children: [
                const Text(">>"),
                const SizedBox(width: 12),
                Expanded(
                  child: Platform.isAndroid
                      ? AndroidView(
                          viewType: 'ChatInputEditText',
                          onPlatformViewCreated: (int id) {},
                        )
                      : UiKitView(
                          viewType: 'ChatInputTextView',
                          onPlatformViewCreated: (int id) {},
                        ),
                ),
                // Expanded(child: TextField()),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () async {
                    var text =
                        await handleMethodCall(const MethodCall("getInputText"))
                            as String;
                    sendMessage(text);
                    await handleMethodCall(const MethodCall("clearInputText"));
                  },
                  child: const Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
