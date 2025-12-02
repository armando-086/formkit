import 'package:formkit/src/validation/contract/i_async_validator.dart';
import 'package:formkit/src/core/contracts/i_disposable.dart';
import 'package:formkit/src/state/state/field_state_store.dart';

abstract interface class IAsyncValidatorService<P> implements IDisposable {
  void validate(
    P? value,
    List<IAsyncValidator<P>> validators,
    FieldStateStore stateStore,
  );
  void cancel();

  /// Desencadena la validación asíncrona inmediatamente y devuelve un [Future]
  /// que se completa cuando la validación ha terminado.
  /// Usado para operaciones de 'flush' (envío del formulario).
  Future<void> flushValidation(
    P value,
    List<IAsyncValidator<P>> validators,
    FieldStateStore stateStore,
  );
}