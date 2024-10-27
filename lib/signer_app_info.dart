
class SignerAppInfo {
  final String name;
  final String packageName;
  final String iconData;

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
