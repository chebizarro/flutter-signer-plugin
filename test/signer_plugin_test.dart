import 'package:flutter_test/flutter_test.dart';
import 'package:signer_plugin/signer_plugin_platform_interface.dart';
import 'package:signer_plugin/signer_plugin_method_channel.dart';

void main() {
  test('default instance is MethodChannelSignerPlugin', () {
    expect(SignerPluginPlatform.instance, isA<MethodChannelSignerPlugin>());
  });
}
