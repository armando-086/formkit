import 'package:formkit/src/core/contracts/i_disposable.dart';
//. =============================================================
//. Contrato para el enlace entre FieldOrchestrator y los Widgets de Flutter.
//. P: Tipo Primitivo (valor de entrada del widget).
//. =============================================================
abstract interface class IFieldBinder implements IDisposable {
  String get name;
  void setErrorMsg(String? msg); 
  dynamic getCurrentRawValue();
}