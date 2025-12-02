import 'package:formkit/src/exceptions/formkit_exeption.dart';

class FormKitStructureException extends FormKitException {
  FormKitStructureException(super.message);
  @override
  String toString() => 'FormKitStructureException: $message';
}