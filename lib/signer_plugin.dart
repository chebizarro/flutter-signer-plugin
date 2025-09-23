import 'dart:io' show Platform;
import 'package:signer_plugin/signer_app_info.dart';
import 'package:signer_plugin/nip55_exceptions.dart';

import 'signer_plugin_platform_interface.dart';

class SignerPlugin {
  static const int maxPayloadBytes = 256 * 1024; // 256 KB
  static const Duration defaultTimeout = Duration(seconds: 30);

  void _ensureAndroid() {
    if (!Platform.isAndroid) {
      throw const Nip55NotSupported('NIP-55 is only supported on Android');
    }
  }

  void _checkSize(String value, String name) {
    if (value.codeUnits.length > maxPayloadBytes) {
      throw Nip55ValidationException(
          '$name exceeds size limit of $maxPayloadBytes bytes');
    }
  }

  Future<bool> isExternalSignerInstalled(String packageName) {
    _ensureAndroid();
    return SignerPluginPlatform.instance.isExternalSignerInstalled(packageName)
        .timeout(defaultTimeout);
  }

  Future<List<SignerAppInfo>> getInstalledSignerApps() {
    _ensureAndroid();
    return SignerPluginPlatform.instance.getInstalledSignerApps()
        .timeout(defaultTimeout);
  }

  Future<void> setPackageName(String packageName) {
    _ensureAndroid();
    return SignerPluginPlatform.instance.setPackageName(packageName)
        .timeout(defaultTimeout);
  }

  Future<Map<String, dynamic>> getPublicKey({String? permissions}) {
    _ensureAndroid();
    if (permissions != null) _checkSize(permissions, 'permissions');
    return SignerPluginPlatform.instance.getPublicKey(permissions)
        .timeout(defaultTimeout);
  }

  Future<Map<String, dynamic>> signEvent(
      String eventJson, String eventId, String npub) {
    _ensureAndroid();
    _checkSize(eventJson, 'eventJson');
    _checkSize(eventId, 'eventId');
    _checkSize(npub, 'npub');
    return SignerPluginPlatform.instance.signEvent(eventJson, eventId, npub)
        .timeout(defaultTimeout);
  }

  Future<Map<String, dynamic>> nip04Encrypt(
      String plainText, String id, String npub, String pubKey) {
    _ensureAndroid();
    _checkSize(plainText, 'plainText');
    _checkSize(id, 'id');
    _checkSize(npub, 'npub');
    _checkSize(pubKey, 'pubKey');
    return SignerPluginPlatform.instance
        .nip04Encrypt(plainText, id, npub, pubKey)
        .timeout(defaultTimeout);
  }

  Future<Map<String, dynamic>> nip04Decrypt(
      String encryptedText, String id, String npub, String pubKey) {
    _ensureAndroid();
    _checkSize(encryptedText, 'encryptedText');
    _checkSize(id, 'id');
    _checkSize(npub, 'npub');
    _checkSize(pubKey, 'pubKey');
    return SignerPluginPlatform.instance
        .nip04Decrypt(encryptedText, id, npub, pubKey)
        .timeout(defaultTimeout);
  }

  Future<Map<String, dynamic>> nip44Encrypt(
      String plainText, String id, String npub, String pubKey) {
    _ensureAndroid();
    _checkSize(plainText, 'plainText');
    _checkSize(id, 'id');
    _checkSize(npub, 'npub');
    _checkSize(pubKey, 'pubKey');
    return SignerPluginPlatform.instance
        .nip44Encrypt(plainText, id, npub, pubKey)
        .timeout(defaultTimeout);
  }

  Future<Map<String, dynamic>> nip44Decrypt(
      String encryptedText, String id, String npub, String pubKey) {
    _ensureAndroid();
    _checkSize(encryptedText, 'encryptedText');
    _checkSize(id, 'id');
    _checkSize(npub, 'npub');
    _checkSize(pubKey, 'pubKey');
    return SignerPluginPlatform.instance
        .nip44Decrypt(encryptedText, id, npub, pubKey)
        .timeout(defaultTimeout);
  }

  Future<Map<String, dynamic>> decryptZapEvent(
      String eventJson, String id, String npub) {
    _ensureAndroid();
    _checkSize(eventJson, 'eventJson');
    _checkSize(id, 'id');
    _checkSize(npub, 'npub');
    return SignerPluginPlatform.instance
        .decryptZapEvent(eventJson, id, npub)
        .timeout(defaultTimeout);
  }

  Future<Map<String, dynamic>> getRelays(String id, String npub) {
    _ensureAndroid();
    _checkSize(id, 'id');
    _checkSize(npub, 'npub');
    return SignerPluginPlatform.instance.getRelays(id, npub)
        .timeout(defaultTimeout);
  }
}
