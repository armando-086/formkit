import 'package:formkit/src/config/contracts/i_form_schema.dart';

abstract interface class IState {
  bool get isValid;
  bool get isDirty;
  bool get isTouched;
  String? get errorMsg;
  IFormSchema get config;
}
