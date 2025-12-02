import 'dart:async';
import 'package:formkit/src/validation/contract/i_async_validator.dart';
import 'package:formkit/src/validation/contract/i_validator.dart';

class FakeSyncValidator<T> implements IValidator<T> {
  //. Configuración para simular un error sincrónico
  String? syncErrorMsg;
  
  FakeSyncValidator({this.syncErrorMsg});

  @override
  //. Ahora implementa IValidator.validate correctamente.
  String? validate(T value, {String? fieldName}) {
    return syncErrorMsg;
  }
}

//. Implementa solo IAsyncValidator (Validación Asincrónica)
class FakeAsyncValidator<P> implements IAsyncValidator<P> {
  //. Configuración para simular un error asincrónico
  String? asyncErrorMsg;
  
  //. Simulación de tiempo de respuesta asíncrona
  final Duration asyncDelay;

  FakeAsyncValidator({this.asyncErrorMsg, this.asyncDelay = const Duration(milliseconds: 1)});

  @override
  //. Ahora implementa IAsyncValidator.validate correctamente.
  Future<String?> validate(P value) async {
    //. Simula una operación asíncrona (ej. llamada a servidor)
    await Future.delayed(asyncDelay);
    return asyncErrorMsg;
  }
}