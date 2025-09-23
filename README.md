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
  signer_plugin: ^0.0.2
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
final signer = SignerPlugin();
// Optionally set a preferred signer package once
await signer.setPackageName('com.example.signer');
final res = await signer.getPublicKey();
final publicKey = res['npub'] as String; // bech32 npub
print('Public Key length: ${publicKey.length}');
```

### Sign Event

Sign a Nostr event represented as a JSON string:

```dart
final signer = SignerPlugin();
final pubRes = await signer.getPublicKey();
final npub = pubRes['npub'] as String;
final eventId = '...computed id...';
final eventJson = '{"id":"$eventId","kind":1,"content":"Hello","tags":[],"pubkey":"...hex..."}';
final signRes = await signer.signEvent(eventJson, eventId, npub);
// keys: signature, id, event
print('Signed event length: ${signRes['event'].toString().length}');
```

## API Reference

### Methods (Android only)

All methods return `Future<Map<String, dynamic>>` with consistent keys.

- `getPublicKey({String? permissionsJson})` → `{ npub, package }`
- `signEvent(String eventJson, String eventId, String npub)` → `{ signature, id, event }`
- `nip04Encrypt(String plainText, String id, String npub, String pubKey)` → `{ result, id }`
- `nip04Decrypt(String encryptedText, String id, String npub, String pubKey)` → `{ result, id }`
- `nip44Encrypt(String plainText, String id, String npub, String pubKey)` → `{ result, id }`
- `nip44Decrypt(String encryptedText, String id, String npub, String pubKey)` → `{ result, id }`
- `decryptZapEvent(String eventJson, String id, String npub)` → `{ result, id }`
- `getRelays(String id, String npub)` → `{ result, id }`

Utilities:

- `setPackageName(String packageName)` sets a preferred signer package used by subsequent calls.
- `getInstalledSignerApps()` returns installed signers with `{name, packageName, iconData, iconUrl?}`.
- `isExternalSignerInstalled(String packageName)` returns `bool`.

## Example

See `example/` for a runnable app demonstrating:

- Listing installed signer apps and selecting one
- Getting public key
- Signing an event
- NIP-04/NIP-44 encrypt/decrypt
- Getting relays

All examples avoid logging sensitive payloads; only lengths are printed.

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
