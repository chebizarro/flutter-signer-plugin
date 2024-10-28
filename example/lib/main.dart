import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:signer_plugin/signer_plugin.dart';
import 'package:signer_plugin/signer_app_info.dart';
import 'package:bech32/bech32.dart';
import 'package:hex/hex.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String publicKey = '';
  String eventContent = '';
  String signedEvent = '';
  String encryptPubKey = '';
  String messageToEncrypt = '';
  String encryptedMessage = '';
  String decryptedMessage = '';
  bool signerInstalled = false;
  SignerAppInfo? selectedSignerApp;
  List<SignerAppInfo> signerApps = [];
  bool isScriptActive = false;
  dynamic relays;

  final _signerPlugin = SignerPlugin();

  TextEditingController eventContentController = TextEditingController();
  TextEditingController encryptPubKeyController = TextEditingController();
  TextEditingController messageToEncryptController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadSignerApps();
  }

  Future<void> loadSignerApps() async {
    List<SignerAppInfo> apps = [];
    try {
      apps = await _signerPlugin.getInstalledSignerApps();
      print("No. of apps: ${apps.length}");
    } catch (e) {
      print('Error: $e');
    }

    if (!mounted) return;

    setState(() {
      signerApps = apps;
    });
  }

  void selectSignerApp(SignerAppInfo app) {
    setState(() {
      selectedSignerApp = app;
    });
    _signerPlugin.setPackageName(app.packageName);
    checkSignerInstalled(app.packageName);
  }

  Future<void> checkSignerInstalled(String app) async {
    try {
      bool installed = await _signerPlugin.isExternalSignerInstalled(app);
      setState(() {
        signerInstalled = installed;
      });
    } catch (e) {
      print('Error checking signer installation: $e');
      setState(() {
        signerInstalled = false;
      });
    }
  }

  Future<void> getPublicKey() async {
    try {
      final pubKeyResult = await _signerPlugin.getPublicKey();
      setState(() {
        publicKey = pubKeyResult['npub'];
      });
    } catch (e) {
      print('Error getting public key: $e');
    }
  }

  Future<void> signEvent() async {
    try {
      String pubKeyHex = decodeNpub(publicKey);

      Map<String, dynamic> event = {
        'kind': 1,
        'created_at': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        'content': eventContentController.text,
        'tags': [],
        'pubkey': pubKeyHex,
        'sig': '',
      };

      String eventHash = getEventHash(event);
      event['id'] = eventHash;

      final signResult = await _signerPlugin.signEvent(
        jsonEncode(event),
        eventHash,
        publicKey,
      );

      setState(() {
        signedEvent = signResult['event'];
      });
    } catch (e) {
      print('Error signing event: $e');
    }
  }

  Future<void> encryptMessage() async {
    try {
      String recipientPubKeyHex = decodeNpub(encryptPubKeyController.text);
      String plainText = messageToEncryptController.text;

      Map<String, dynamic> result;

      if (isScriptActive) {
        result = await _signerPlugin.nip44Encrypt(
            plainText, "", publicKey, recipientPubKeyHex);
      } else {
        result = await _signerPlugin.nip04Encrypt(
            plainText, "", publicKey, recipientPubKeyHex);
      }

      setState(() {
        encryptedMessage = result['result'];
      });
    } catch (e) {
      print('Error encrypting message: $e');
    }
  }

  Future<void> decryptMessage() async {
    try {
      String senderPubKeyHex = decodeNpub(encryptPubKeyController.text);
      Map<String, dynamic> result;

      if (isScriptActive) {
        result = await _signerPlugin.nip44Decrypt(
            encryptedMessage, "", publicKey, senderPubKeyHex);
      } else {
        result = await _signerPlugin.nip04Decrypt(
            encryptedMessage, "", publicKey, senderPubKeyHex);
      }

      setState(() {
        decryptedMessage = result['result'];
      });
    } catch (e) {
      print('Error decrypting message: $e');
    }
  }

  Future<void> getRelays() async {
    try {
      final result = await _signerPlugin.getRelays("", publicKey);
      setState(() {
        relays = result['result'];
      });
    } catch (e) {
      print('Error fetching relays: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Nostr Signer Plugin Example')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Installed Signer Apps
                const Text('Installed Signer Apps',
                    style: TextStyle(fontSize: 24)),
                if (signerApps.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: signerApps.length,
                    itemBuilder: (context, index) {
                      final app = signerApps[index];
                      return ListTile(
                        //leading: Image.memory(app.icon),
                        title: Text(app.name),
                        onTap: () => selectSignerApp(app),
                      );
                    },
                  )
                else
                  const Text('No signer apps installed.'),

                const SizedBox(height: 20),

                // Get Public Key
                ElevatedButton(
                  onPressed: signerInstalled ? getPublicKey : null,
                  child: const Text('Get Public Key'),
                ),
                if (publicKey.isNotEmpty) Text('Public Key: $publicKey'),

                const SizedBox(height: 20),

                // Sign Event
                const Text('Sign Event', style: TextStyle(fontSize: 24)),
                TextField(
                  controller: eventContentController,
                  decoration: const InputDecoration(
                    labelText: 'Event Content',
                  ),
                ),
                ElevatedButton(
                  onPressed: signerInstalled ? signEvent : null,
                  child: const Text('Sign Event'),
                ),
                if (signedEvent.isNotEmpty) Text('Signed Event:\n$signedEvent'),

                const SizedBox(height: 20),

                // Encryption
                const Text('Encryption', style: TextStyle(fontSize: 24)),
                TextField(
                  controller: encryptPubKeyController,
                  decoration: const InputDecoration(
                    labelText: 'Recipient Public Key',
                  ),
                ),
                TextField(
                  controller: messageToEncryptController,
                  decoration: const InputDecoration(
                    labelText: 'Message to Encrypt',
                  ),
                ),
                Row(
                  children: [
                    Switch(
                      value: isScriptActive,
                      onChanged: (value) {
                        setState(() {
                          isScriptActive = value;
                        });
                      },
                    ),
                    Text(isScriptActive ? 'NIP-44' : 'NIP-04'),
                  ],
                ),
                ElevatedButton(
                  onPressed: signerInstalled ? encryptMessage : null,
                  child: const Text('Encrypt Message'),
                ),
                ElevatedButton(
                  onPressed: signerInstalled ? decryptMessage : null,
                  child: const Text('Decrypt Message'),
                ),
                if (encryptedMessage.isNotEmpty)
                  Text('Encrypted Message:\n$encryptedMessage'),
                if (decryptedMessage.isNotEmpty)
                  Text('Decrypted Message:\n$decryptedMessage'),

                const SizedBox(height: 20),

                // Get Relays
                ElevatedButton(
                  onPressed: signerInstalled ? getRelays : null,
                  child: const Text('Get Relays'),
                ),
                if (relays != null) Text('Relays:\n${relays.toString()}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String getEventHash(Map<String, dynamic> event) {
  return "";
}

String decodeNpub(String publicKey) {
  var decodedKey = decode(publicKey);
  return decodedKey;
}

// "Borrowed" from NDK
String decode(String npub) {
  try {
    var decoder = Bech32Decoder();
    var bech32Result = decoder.convert(npub);
    var data = convertBits(bech32Result.data, 5, 8, false);
    return HEX.encode(data);
  } catch (e) {
    return "";
  }
}

List<int> convertBits(List<int> data, int from, int to, bool pad) {
  var acc = 0;
  var bits = 0;
  var result = <int>[];
  var maxv = (1 << to) - 1;

  for (var v in data) {
    if (v < 0 || (v >> from) != 0) {
      throw Exception();
    }
    acc = (acc << from) | v;
    bits += from;
    while (bits >= to) {
      bits -= to;
      result.add((acc >> bits) & maxv);
    }
  }

  if (pad) {
    if (bits > 0) {
      result.add((acc << (to - bits)) & maxv);
    }
  } else if (bits >= from) {
    throw InvalidPadding('illegal zero padding');
  } else if (((acc << (to - bits)) & maxv) != 0) {
    throw InvalidPadding('non zero');
  }

  return result;
}
