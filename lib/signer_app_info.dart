
class SignerAppInfo {
  final String name;
  final String packageName;
  final String iconData;
  final String? iconUrl;

  SignerAppInfo({
    required this.name,
    required this.packageName,
    required this.iconData,
    this.iconUrl,
  });

  factory SignerAppInfo.fromMap(Map<String, dynamic> map) {
    return SignerAppInfo(
      name: (map['name'] ?? '') as String,
      packageName: (map['packageName'] ?? '') as String,
      iconData: (map['iconData'] ?? '') as String,
      iconUrl: map['iconUrl'] as String?,
    );
  }
}
