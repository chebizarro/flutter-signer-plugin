// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://flutter.dev/to/integration-testing


import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:nip55/signer_plugin.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final plugin = SignerPlugin();

  testWidgets('getPublicKey real test', (WidgetTester tester) async {
    // Attempt to call the actual native method
    try {
      final result = await plugin.getPublicKey(
        permissions: '[{"type":"sign_event"}]',
      );
      print('Got public key: $result');
      expect(result.containsKey('npub'), isTrue);
    } catch (e) {
      fail('getPublicKey failed: $e');
    }
  });

  testWidgets('signEvent real test', (WidgetTester tester) async {
    try {
      final result = await plugin.signEvent(
        '{"content":"Hello"}',
        'evt123',
        'npubUser',
      );
      print('Signed event: $result');
      expect(result['signature'], isNotNull);
    } catch (e) {
      fail('signEvent failed: $e');
    }
  });

}
