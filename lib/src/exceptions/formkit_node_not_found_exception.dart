import 'package:formkit/src/exceptions/formkit_exeption.dart';

class FormKitNodeNotFoundException extends FormKitException {
  FormKitNodeNotFoundException(String name)
      : super('Node "$name" not found in the form structure.');
}