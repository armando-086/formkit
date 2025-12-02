//. Clase base abstracta para todas las excepciones de FormKit.
class FormKitException implements Exception {
  final String message;
  FormKitException(this.message);
  @override
  String toString() => 'FormKitException: $message';
}


