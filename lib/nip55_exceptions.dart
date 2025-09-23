import 'package:meta/meta.dart';

@immutable
sealed class Nip55Exception implements Exception {
  final String message;
  final Object? details;
  const Nip55Exception(this.message, {this.details});
  @override
  String toString() => '$runtimeType: $message';
}

class Nip55NotSupported extends Nip55Exception {
  const Nip55NotSupported(super.message, {super.details});
}

class Nip55ValidationException extends Nip55Exception {
  const Nip55ValidationException(super.message, {super.details});
}

class Nip55PlatformException extends Nip55Exception {
  const Nip55PlatformException(super.message, {super.details});
}
