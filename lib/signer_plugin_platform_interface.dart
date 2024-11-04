import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:signer_plugin/signer_app_info.dart';

import 'signer_plugin_method_channel.dart';

abstract class SignerPluginPlatform extends PlatformInterface {
  /// Constructs a SignerPluginPlatform.
  SignerPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static SignerPluginPlatform _instance = MethodChannelSignerPlugin();

  /// The default instance of [SignerPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelSignerPlugin].
  static SignerPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SignerPluginPlatform] when
  /// they register themselves.
  static set instance(SignerPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> isExternalSignerInstalled(String packageName) async {
    throw UnimplementedError('isExternalSignerInstalled() has not been implemented.');
  }

  Future<List<SignerAppInfo>> getInstalledSignerApps() async {
    throw UnimplementedError('getInstalledSignerApps() has not been implemented.');
  }

  Future<void> setPackageName(String packageName) async {
    throw UnimplementedError('setPackageName() has not been implemented.');
  }

  Future<Map<String, dynamic>> getPublicKey(String? permissions) async {
    throw UnimplementedError('getPublicKey() has not been implemented.');
  }

  Future<Map<String, dynamic>> signEvent(String eventJson, String eventId, String npub) async {
    throw UnimplementedError('signEvent() has not been implemented.');
  }

  Future<Map<String, dynamic>> nip04Encrypt(String plainText, String id, String npub, String pubKey) async {
    throw UnimplementedError('nip04Encrypt() has not been implemented.');
  }

  Future<Map<String, dynamic>> nip04Decrypt(String encryptedText, String id, String npub, String pubKey) async {
    throw UnimplementedError('nip04Decrypt() has not been implemented.');
  }

  Future<Map<String, dynamic>> nip44Encrypt(String plainText, String id, String npub, String pubKey) async {
    throw UnimplementedError('nip44Encrypt() has not been implemented.');
  }

  Future<Map<String, dynamic>> nip44Decrypt(String encryptedText, String id, String npub, String pubKey) async {
    throw UnimplementedError('nip44Decrypt() has not been implemented.');
  }

  Future<Map<String, dynamic>> decryptZapEvent(String eventJson, String id, String npub) async {
    throw UnimplementedError('decryptZapEvent() has not been implemented.');
  }

  Future<Map<String, dynamic>> getRelays(String id, String npub) async {
    throw UnimplementedError('getRelays() has not been implemented.');
  }

}
