import 'package:flutter_test/flutter_test.dart';
import 'package:signer_plugin/signer_plugin.dart';
import 'package:signer_plugin/signer_plugin_platform_interface.dart';
import 'package:signer_plugin/signer_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSignerPluginPlatform
    with MockPlatformInterfaceMixin
    implements SignerPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
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

    expect(await signerPlugin.getPlatformVersion(), '42');
  });
}
