import 'package:flutter_test/flutter_test.dart';
import 'package:nip55/signer_app_info.dart';
import 'package:nip55/signer_plugin.dart';
import 'package:nip55/signer_plugin_platform_interface.dart';
import 'package:nip55/signer_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSignerPluginPlatform
    with MockPlatformInterfaceMixin
    implements SignerPluginPlatform {
  @override
  Future<Map<String, dynamic>> decryptZapEvent(String eventJson, String id, String npub) {
    // TODO: implement decryptZapEvent
    throw UnimplementedError();
  }

  @override
  Future<List<SignerAppInfo>> getInstalledSignerApps() {
    // TODO: implement getInstalledSignerApps
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getPublicKey(String? permissions) {
    // TODO: implement getPublicKey
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getRelays(String id, String npub) {
    // TODO: implement getRelays
    throw UnimplementedError();
  }

  @override
  Future<bool> isExternalSignerInstalled(String packageName) {
    // TODO: implement isExternalSignerInstalled
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> nip04Decrypt(String encryptedText, String id, String npub, String pubKey) {
    // TODO: implement nip04Decrypt
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> nip04Encrypt(String plainText, String id, String npub, String pubKey) {
    // TODO: implement nip04Encrypt
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> nip44Decrypt(String encryptedText, String id, String npub, String pubKey) {
    // TODO: implement nip44Decrypt
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> nip44Encrypt(String plainText, String id, String npub, String pubKey) {
    // TODO: implement nip44Encrypt
    throw UnimplementedError();
  }

  @override
  Future<void> setPackageName(String packageName) {
    // TODO: implement setPackageName
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> signEvent(String eventJson, String eventId, String npub) {
    // TODO: implement signEvent
    throw UnimplementedError();
  }

}

void main() {
  final SignerPluginPlatform initialPlatform = SignerPluginPlatform.instance;

  test('$MethodChannelSignerPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSignerPlugin>());
  });

  test('getPlatformVersion', () async {
    SignerPlugin signerPlugin = SignerPlugin();
    MockSignerPluginPlatform fakePlatform = MockSignerPluginPlatform();
    SignerPluginPlatform.instance = fakePlatform;

  });
}
