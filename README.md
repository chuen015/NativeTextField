### Description

Utilize native input text components of Android / iOS on a **Flutter** project

### Introduction

Modern chat apps often allow users to paste rich content and send images.

<img src="https://github.com/chuen015/NativeTextField/assets/15151778/0ccb85cc-a3f3-49fe-8c62-1dc73b53ca58" width="500">

However, the `TextField` widget in the Flutter SDK currently lacks this feature. On Android, for example, long-pressing the `TextField` does not show the “Paste” option.

To enable the “pasting” of rich content in a TextField, we are utilizing native UI components: EditText on Android and UITextView on iOS. This is achieved by employing [custom platform-specific code](https://docs.flutter.dev/platform-integration/platform-channels), and hosting platform-specific provided by Flutter, as detailed in the Platform Channels documentation, and hosting platform-specific UI components in a Flutter widget.

For more information, see:
- [Hosting native iOS views in your Flutter app with Platform Views](https://docs.flutter.dev/platform-integration/ios/platform-views)
- [Hosting native Android views in your Flutter app with Platform Views](https://docs.flutter.dev/platform-integration/android/platform-views)


<img src="https://github.com/chuen015/NativeTextField/assets/15151778/8b945069-a9bf-4821-a8ff-116d5e0c62c2" width="450">

Additionally, the Flutter SDK supports image insertion via the keyboard on Android, as highlighted in [PR](https://github.com/flutter/flutter/pull/110052)
