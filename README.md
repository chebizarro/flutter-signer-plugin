# Flutter Nostr Signer Plugin

A Flutter plugin that provides signing capabilities for Nostr applications, implementing [NIP-55](https://github.com/nostr-protocol/nips/blob/master/55.md). This plugin allows developers to sign Nostr events with their Flutter apps and an installed Android Signer like Amber, securely and efficiently.

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [API Reference](#api-reference)
- [Example](#example)
- [NIP-55 Compliance](#nip-55-compliance)
- [Contributing](#contributing)
- [License](#license)

## Introduction

The Flutter Nostr Signer Plugin enables Flutter applications to interact with [Nostr](https://nostr.com/) decentralized protocol by providing native signing capabilities. By adhering to [NIP-55](https://github.com/nostr-protocol/nips/blob/master/55.md), this plugin ensures secure and standardized signing of Nostr events, facilitating seamless integration with Android Signer apps.

## Features

- **Sign Nostr Events**: Securely sign events to interact with the Nostr protocol.
- **Retrieve Public Keys**: Access the user's public key for identity verification.
- **NIP-55 Compliance**: Fully implements the NIP-55 specification for application-level signing.

## Installation

Add the plugin to your project's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_nostr_signer_plugin: ^1.0.0
```

Then, run the following command to fetch the plugin:

```bash
flutter pub get
```

## Usage

Import the plugin in your Dart code:

```dart
import 'package:signer_plugin/signer_plugin.dart';
```

### Initialize the Plugin

You can create an instance of the plugin if needed:

```dart
final nostrSigner = SignerPlugin();
```

### Get Public Key

Retrieve the user's public key:

```dart
String publicKey = await SignerPlugin.getPublicKey();
print('Public Key: $publicKey');
```

### Sign Event

Sign a Nostr event represented as a JSON string:

```dart
String eventJson = '{id:"", "content": "Hello, Nostr!", ...}';
String signedEvent = await FlutterNostrSignerPlugin.signEvent(eventJson);
print('Signed Event: $signedEvent');
```

## API Reference

### Methods

#### `Future<String> getPublicKey()`

Retrieves the user's public key.

**Returns:**

- `String`: The public key in hexadecimal format.

#### `Future<String> signEvent(String eventJson)`

Signs a Nostr event.

**Parameters:**

- `eventJson` (`String`): A JSON string representing the event to be signed.

**Returns:**

- `String`: The signed event in JSON format.

## Example

Below is a complete example demonstrating how to use the plugin:

```dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:signer_plugin/signer_plugin.dart';
import 'package:ndk/shared/nips/nip19/nip19.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _publicKey = 'Unknown';
  String _signedEvent = 'Unknown';

  @override
  void initState() {
    super.initState();
    initSigner();
  }

  Future<void> initSigner() async {
    String publicKey;
    String signedEvent;

    try {
      publicKey = await SignerPlugin.getPublicKey();
      String eventJson = '{"content": "Hello, Nostr!"}';
	  String pk = Nip19.decode(publicKey);
      signedEvent = await SignerPlugin.signEvent(eventJson, pk);
    } catch (e) {
      publicKey = 'Failed to get public key: $e';
      signedEvent = 'Failed to sign event: $e';
    }

    if (!mounted) return;

    setState(() {
      _publicKey = publicKey;
      _signedEvent = signedEvent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Flutter Nostr Signer Plugin Example')),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Public Key: $_publicKey\n', textAlign: TextAlign.center),
                Text('Signed Event: $_signedEvent\n', textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

## NIP-55 Compliance

This plugin implements the [NIP-55](https://github.com/nostr-protocol/nips/blob/master/55.md) specification, which defines the protocol for application-level signing of Nostr events on Android. By adhering to NIP-55, the plugin ensures secure and standardized interactions with the Nostr network, promoting interoperability between different Nostr clients and services.

## Contributing

Contributions are welcome! If you'd like to contribute to this project, please follow these steps:

1. **Fork the Repository**: Click the 'Fork' button at the top right of the repository page.

2. **Clone Your Fork**:

   ```bash
   git clone https://github.com/chebizarro/flutter-signer-plugin.git
   cd flutter-signer-plugin
   ```

3. **Create a New Branch**:

   ```bash
   git checkout -b feature/your-feature-name
   ```

4. **Make Your Changes**: Implement your feature or bug fix.

5. **Commit Your Changes**:

   ```bash
   git commit -am 'Add some feature'
   ```

6. **Push to the Branch**:

   ```bash
   git push origin feature/your-feature-name
   ```

7. **Open a Pull Request**: Go to the repository on GitHub and click 'New pull request'.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

**Note**: For any issues or questions, please open an issue on the [GitHub repository](https://github.com/chebizarro/flutter-signer-plugin/issues).
