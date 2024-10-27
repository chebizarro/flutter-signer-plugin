import 'package:flutter/material.dart';
import 'package:signer_plugin/signer_app_info.dart';
import 'dart:async';

import 'package:signer_plugin/signer_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _publicKey = 'Unknown';
  String _signature = 'Unknown';
  List<SignerAppInfo> signerApps = [];

  final _signerPlugin = SignerPlugin();

  @override
  void initState() {
    super.initState();
    loadSignerApps();
    initPlatformState();
  }

  Future<void> loadSignerApps() async {
    List<SignerAppInfo> apps = [];
    try {
      apps = await _signerPlugin.getInstalledSignerApps();
      print("No. of apps: " + apps.length.toString());
    } catch (e) {
      print('Error: $e');
    }

    if (!mounted) return;

    setState(() {
      signerApps = apps;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String publicKey;
    String signature;

    try {
      // Set package name if needed
      await _signerPlugin.setPackageName('com.example.signerapp');

      // Check if signer is installed
      bool isInstalled = await _signerPlugin
          .isExternalSignerInstalled('com.example.signerapp');

      isInstalled = signerApps.isNotEmpty;
      if (isInstalled) {
        // Get public key
        Map<String, dynamic> pubKeyResult = await _signerPlugin.getPublicKey();
        publicKey = pubKeyResult['npub'];

        // Sign event
        Map<String, dynamic> signResult = await _signerPlugin.signEvent(
            '{"content":"Hello Nostr"}', 'event123', publicKey);
        signature = signResult['signature'];
      } else {
        publicKey = 'Signer app not installed';
        signature = 'Cannot sign event';
      }
    } catch (e) {
      publicKey = 'Error: $e';
      signature = 'Error: $e';
    }

    if (!mounted) return;

    setState(() {
      _publicKey = publicKey;
      _signature = signature;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Nostr Signer Plugin Example')),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Public Key: $_publicKey\n'),
                Text('Signature: $_signature\n'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
