import 'package:signer_plugin/signer_app_info.dart';

import 'signer_plugin_platform_interface.dart';

class SignerPlugin {
  Future<String?> getPlatformVersion() {
    return SignerPluginPlatform.instance.getPlatformVersion();
  }

  Future<bool> isExternalSignerInstalled(String packageName) {
    return SignerPluginPlatform.instance.isExternalSignerInstalled(packageName);
  }

  Future<List<SignerAppInfo>> getInstalledSignerApps() {
    return SignerPluginPlatform.instance.getInstalledSignerApps();
  }

  Future<void> setPackageName(String packageName) {
    return SignerPluginPlatform.instance.setPackageName(packageName);
  }

  Future<Map<String, dynamic>> getPublicKey({String? permissions}) {
    return SignerPluginPlatform.instance.getPublicKey(permissions);
  }

  Future<Map<String, dynamic>> signEvent(
      String eventJson, String eventId, String npub) {
    return SignerPluginPlatform.instance.signEvent(eventJson, eventId, npub);
  }

  Future<Map<String, dynamic>> nip04Encrypt(
      String plainText, String id, String npub, String pubKey) {
    return SignerPluginPlatform.instance
        .nip04Encrypt(plainText, id, npub, pubKey);
  }

  Future<Map<String, dynamic>> nip04Decrypt(
      String encryptedText, String id, String npub, String pubKey) {
    return SignerPluginPlatform.instance
        .nip04Decrypt(encryptedText, id, npub, pubKey);
  }

  Future<Map<String, dynamic>> nip44Encrypt(
      String plainText, String id, String npub, String pubKey) {
    return SignerPluginPlatform.instance
        .nip44Encrypt(plainText, id, npub, pubKey);
  }

  Future<Map<String, dynamic>> nip44Decrypt(
      String encryptedText, String id, String npub, String pubKey) {
    return SignerPluginPlatform.instance
        .nip44Decrypt(encryptedText, id, npub, pubKey);
  }

  Future<Map<String, dynamic>> decryptZapEvent(
      String eventJson, String id, String npub) {
    return SignerPluginPlatform.instance.decryptZapEvent(eventJson, id, npub);
  }

  Future<Map<String, dynamic>> getRelays(
      String eventJson, String id, String npub) {
    return SignerPluginPlatform.instance.getRelays(eventJson, id, npub);
  }
}
