import 'dart:typed_data';

class SignerAppInfo {
  final String name;
  final String packageName;
  final Uint8List iconData;

  SignerAppInfo({
    required this.name,
    required this.packageName,
    required this.iconData,
  });

  factory SignerAppInfo.fromMap(Map<String, dynamic> map) {
    return SignerAppInfo(
      name: map['name'],
      packageName: map['packageName'],
      iconData: map['iconData'],
    );
  }
}
