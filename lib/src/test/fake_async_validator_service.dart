// import 'package:formkit/src/validation/contract/i_async_validator.dart';
// import 'package:formkit/src/validation/contract/i_async_validator_service.dart';
// import 'package:formkit/src/state/state/field_state_store.dart';

// class FakeAsyncValidatorService<P> implements IAsyncValidatorService<P> {
//   // . Permite al test forzar un mensaje de error o null
//   String? forcedErrorMsg;

//   // . Permite al test verificar si la cancelación fue llamada
//   bool cancelCalled = false;

//   // . Permite al test simular un retraso en la validación
//   final Duration validationDelay;

//   FakeAsyncValidatorService({this.forcedErrorMsg, this.validationDelay = const Duration(milliseconds: 1)});

//   @override
//   void validate(
//     P? value,
//     List<IAsyncValidator<P>> validators,
//     FieldStateStore stateStore,
//   ) {
//     // 1. Simular inicio de validación asíncrona
//     stateStore.setIsAsyncValidating(isAsyncValidating: true);

//     // 2. Simular el resultado después de un retraso
//     Future.delayed(validationDelay, () {
//       // 3. Simular el resultado (el store internamente maneja el descarte)
//       stateStore.setIsAsyncValidating(isAsyncValidating: false);
      
//       if (forcedErrorMsg != null) {
//         stateStore.setValidation(isValid: false, errorMsg: forcedErrorMsg);
//       } else {
//         stateStore.setValidation(isValid: true, errorMsg: null);
//       }
//     });
//   }

//   @override
//   void cancel() {
//     cancelCalled = true;
//   }

//   @override
//   void dispose() {
//     // No-op en el Fake
//   }
// }