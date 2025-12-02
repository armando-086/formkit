import 'package:formkit/src/ui/contracts/i_field_binder.dart';

class FakeFieldBinder implements IFieldBinder {
  @override
  final String name;
  
  //. Propiedad que permite a las pruebas verificar qué mensaje de error se estableció
  String? lastErrorMsg;
  //. Propiedad que simula el valor que el Binder le daría al motor
  dynamic currentRawValue;

  FakeFieldBinder({required this.name, this.currentRawValue});

  @override
  void setErrorMsg(String? msg) {
    lastErrorMsg = msg;
  }

  @override
  dynamic getCurrentRawValue() {
    return currentRawValue;
  }

  @override
  void dispose() {
    // No-op
  }
}