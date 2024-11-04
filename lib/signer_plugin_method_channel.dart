import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:signer_plugin/signer_app_info.dart';

import 'signer_plugin_platform_interface.dart';

/// An implementation of [SignerPluginPlatform] that uses method channels.
class MethodChannelSignerPlugin extends SignerPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('signer_plugin');

  // Check if an external signer is installed
  @override
  Future<bool> isExternalSignerInstalled(String packageName) async {
    final bool isInstalled =
        await methodChannel.invokeMethod('isExternalSignerInstalled', {
      'packageName': packageName,
    });
    return isInstalled;
  }

  // Get installed signer apps
  @override
  Future<List<SignerAppInfo>> getInstalledSignerApps() async {
    final List<dynamic> apps =
        await methodChannel.invokeMethod('getInstalledSignerApps');
    return apps
        .map((app) => SignerAppInfo.fromMap(Map<String, dynamic>.from(app)))
        .toList();
  }

  // Set package name
  @override
  Future<void> setPackageName(String packageName) async {
    await methodChannel.invokeMethod('setPackageName', {
      'packageName': packageName,
    });
  }

  // Get public key
  @override
  Future<Map<String, dynamic>> getPublicKey(String? permissions) async {
    final Map<dynamic, dynamic> result =
        await methodChannel.invokeMethod('getPublicKey', {
      'permissions': permissions,
    });
    return Map<String, dynamic>.from(result);
  }

  // Sign event
  @override
  Future<Map<String, dynamic>> signEvent(
      String eventJson, String eventId, String npub) async {
    final Map<dynamic, dynamic> result =
        await methodChannel.invokeMethod('signEvent', {
      'eventJson': eventJson,
      'eventId': eventId,
      'npub': npub,
    });
    return Map<String, dynamic>.from(result);
  }

  @override
  Future<Map<String, dynamic>> nip04Encrypt(
      String plainText, String id, String npub, String pubKey) async {
    final Map<dynamic, dynamic> result =
        await methodChannel.invokeMethod('nip04Encrypt', {
      'plainText': plainText,
      'id': id,
      'npub': npub,
      'pubKey': pubKey,
    });
    return Map<String, dynamic>.from(result);
  }

  @override
  Future<Map<String, dynamic>> nip04Decrypt(
      String encryptedText, String id, String npub, String pubKey) async {
    final Map<dynamic, dynamic> result =
        await methodChannel.invokeMethod('nip04Decrypt', {
      'encryptedText': encryptedText,
      'id': id,
      'npub': npub,
      'pubKey': pubKey,
    });
    return Map<String, dynamic>.from(result);
  }

  @override
  Future<Map<String, dynamic>> nip44Encrypt(
      String plainText, String id, String npub, String pubKey) async {
    final Map<dynamic, dynamic> result =
        await methodChannel.invokeMethod('nip44Encrypt', {
      'plainText': plainText,
      'id': id,
      'npub': npub,
      'pubKey': pubKey,
    });
    return Map<String, dynamic>.from(result);
  }

  @override
  Future<Map<String, dynamic>> nip44Decrypt(
      String encryptedText, String id, String npub, String pubKey) async {
    final Map<dynamic, dynamic> result =
        await methodChannel.invokeMethod('nip44Decrypt', {
      'encryptedText': encryptedText,
      'id': id,
      'npub': npub,
      'pubKey': pubKey,
    });
    return Map<String, dynamic>.from(result);
  }

  @override
  Future<Map<String, dynamic>> decryptZapEvent(
      String eventJson, String id, String npub) async {
    final Map<dynamic, dynamic> result =
        await methodChannel.invokeMethod('decryptZapEvent', {
      'eventJson': eventJson,
      'id': id,
      'npub': npub,
    });
    return Map<String, dynamic>.from(result);
  }

  @override
  Future<Map<String, dynamic>> getRelays(
      String id, String npub) async {
    final Map<dynamic, dynamic> result =
        await methodChannel.invokeMethod('getRelays', {
      'id': id,
      'npub': npub,
    });
    return Map<String, dynamic>.from(result);
  }
}
