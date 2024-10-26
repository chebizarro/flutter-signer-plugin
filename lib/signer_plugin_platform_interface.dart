import 'package:plugin_platform_interface/plugin_platform_interface.dart';

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

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
  
}
