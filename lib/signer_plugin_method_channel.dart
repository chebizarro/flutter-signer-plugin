import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'signer_plugin_platform_interface.dart';

/// An implementation of [SignerPluginPlatform] that uses method channels.
class MethodChannelSignerPlugin extends SignerPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('signer_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
