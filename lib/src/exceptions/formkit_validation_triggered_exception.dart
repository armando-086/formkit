import 'package:formkit/src/exceptions/formkit_exeption.dart';

class FormKitValidationTriggeredException extends FormKitException {
  FormKitValidationTriggeredException()
      : super('UI validation failed. Check errors map.');
      
  @override
  String toString() => 'FormKitValidationTriggeredException: UI validation failed.';
}