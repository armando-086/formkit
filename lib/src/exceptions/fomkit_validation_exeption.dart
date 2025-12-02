import 'package:formkit/src/exceptions/formkit_exeption.dart';

class FormKitValidationException extends FormKitException {
  final Map<String, String> errors;

  FormKitValidationException({
    required String message,
    required this.errors,
  }) : super(message);
  
  @override
  String toString() => 'FormKitValidationException: $message. Errors: $errors';
}