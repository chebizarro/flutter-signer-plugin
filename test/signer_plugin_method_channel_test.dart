import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signer_plugin/signer_plugin_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final platform = MethodChannelSignerPlugin();
  const MethodChannel channel = MethodChannel('signer_plugin');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        if (methodCall.method == 'getPublicKey') {
          return <String, dynamic>{'npub': 'npub1xyz', 'package': 'com.example'};
        }
        throw PlatformException(code: 'UNIMPL');
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getPublicKey success mapping', () async {
    final result = await platform.getPublicKey(null);
    expect(result['npub'], 'npub1xyz');
    expect(result['package'], 'com.example');
  });
}
