
import 'signer_plugin_platform_interface.dart';

class SignerPlugin {

  

  Future<String?> getPlatformVersion() {
    return SignerPluginPlatform.instance.getPlatformVersion();
  }
}
