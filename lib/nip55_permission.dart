import 'package:meta/meta.dart';

@immutable
class Permission {
  final String type; // whitelist
  final int? kind; // >= 0
  final bool checked;
  Permission({required this.type, this.kind, this.checked = true})
      : assert(type != ''),
        assert(allowed.contains(type), 'Invalid permission type: $type'),
        assert(kind == null || kind >= 0, 'kind must be >= 0');

  static const allowed = <String>{
    'get_public_key',
    'sign_event',
    'nip04_encrypt',
    'nip04_decrypt',
    'nip44_encrypt',
    'nip44_decrypt',
    'decrypt_zap_event',
    'get_relays',
  };

  Map<String, dynamic> toJson() => {
        'type': type,
        if (kind != null) 'kind': kind,
        'checked': checked,
      };

  factory Permission.fromJson(Map<String, dynamic> j) => Permission(
        type: j['type'] as String,
        kind: j['kind'] as int?,
        checked: (j['checked'] as bool?) ?? true,
      );
}
