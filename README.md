<p align="center">
<img src="https://user-images.githubusercontent.com/44249868/159565121-bdc4a702-cde8-48be-bc01-9067b40f852e.png" alt="Chucker Flutter" />
</p>
<p align="center">
	<a href="https://pub.dev/packages/chucker_flutter"><img src="https://img.shields.io/pub/v/chucker_flutter" alt="Pub.dev Badge"></a>
	<a href="https://github.com/syedmurtaza108/chucker-flutter/actions"><img src="https://github.com/syedmurtaza108/chucker-flutter/actions/workflows/build.yaml/badge.svg" alt="GitHub Build Badge"></a>
	<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="MIT License Badge"></a>
	<a href="https://github.com/EdsonBueno/focus_detector"><img src="https://img.shields.io/badge/platform-flutter-ff69b4.svg" alt="Flutter Platform Badge"></a>
</p>

* [Getting Started](#getting-started)
* [Features](#features)
* [Hide Header️](#hide-header)
  * 
  * [Decode-Body](#decode-body-)
* [Migrating](#migrating-)
* [Snapshots](#snapshots-)
* [FAQ](#faq-)
* [Contributing](#contributing-)
  * [Building](#building-)
* [Acknowledgments](#acknowledgments-)
* [License](#license-)

# Chucker Flutter

An HTTP requests inspector inspired by <a href="https://github.com/ChuckerTeam/chucker">Chucker Android</a>

Chucker Flutter inspects the **HTTP(S) requests/responses** triggered by your Flutter App. It works as a **Dio Interceptor** and stores data relatated to network requests and responses on local storage, and providing a UI for inspecting and sharing their content.

Flutter Apps, using Chucker Flutter, show in-app **notifications** which tell the status (e.g. 200, 400, 500 and so) and requested url and upon clicking on details button it navigates to Chucker Flutter main screen. You cannot manipulate Chucker Flutter behaviour using its setting by navigating to Settings page from the menu button of Chucker Flutter main page.

# Getting Started

To use Chucker Flutter you need to add the  **pub spec dependency** to your `pubspec.yaml` file of your flutter app.

Please verify the current latest version of Chucker Flutter so that you can enjoy the latest features.

```yaml
dependencies:
  chucker_flutter: latest-version
```

To make `ChuckerDioInterceptor` work, just add it in your `Dio` object e.g.:

```dart
Dio().interceptors.add(ChuckerDioInterceptor());
```

The very last thing is to connect Chucker Flutter screens to your app. To do so, you only need to add Chucker Flutter's `NavigatorObserver` in your app's `MaterialApp`  e.g.:

```dart
MaterialApp(
      ...,
      navigatorObservers: [ChuckerFlutter.navigatorObserver],
```

**Congratulations!** 🎊 You are done. Rest on us!

## Features

* Support for **Dio**
* Works in all (Windows💻, Linux🖥️, Mac🧑‍💻, Android📱, iOS📲) platforms 
* Easy integration
* Customization
* Localization (Current support for English 🇺🇸 and Urdu 🇵🇰)
* Searching🔍 and sharing👯
* Json responses in tree form 🌴 (Thanks to <a href="https://pub.dev/packages/flutter_json_viewer/install">Flutter Json Viewer</a>)

### Hide-Header

**Warning** The data stored by Chucker Flutter may contain sensitive information such as Authorization headers.

It is intended for **use during development**, and not in release builds or other production deployments.

You can redact headers that contain sensitive information by calling `redactHeader(String)` on the `ChuckerInterceptor`.

### Libraries

Chucker FLutter uses the following open source libraries:

- [flutter_json_viewer](https://pub.dev/packages/flutter_json_viewer/install)
- [dio](https://pub.dev/packages/dio) - flutterchina.club
- [shared_preferences](https://pub.dev/packages/shared_preferences) - flutter.dev
- [share_plus](https://pub.dev/packages/share_plus) - fluttercommunity.dev

## License 📄

```
    MIT License

Copyright (c) 2022 Syed Murtaza

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```