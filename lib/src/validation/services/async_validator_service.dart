import 'dart:async';
import 'package:formkit/src/validation/contract/i_async_validator.dart';
import 'package:formkit/src/validation/contract/i_async_validator_service.dart';
import 'package:formkit/src/state/state/field_state_store.dart';

class AsyncValidatorService<P> implements IAsyncValidatorService<P> {
  Timer? _debounceTimer;
  StreamSubscription<void>? _validationSubscription;
  
  static const Duration _debounceDuration = Duration(milliseconds: 300);

  @override
  void validate(
    P? value,
    List<IAsyncValidator<P>> validators,
    FieldStateStore stateStore,
  ) {
    cancel(); 
    if (validators.isEmpty || (value == null && null is! P)) {
      stateStore.setIsAsyncValidating(isAsyncValidating: false);
      return;
    }
    stateStore.setIsAsyncValidating(isAsyncValidating: true);

    _debounceTimer = Timer(_debounceDuration, () {
      Future<String?> validationFuture = _aggregateAsyncValidation(value as P, validators);

      _validationSubscription = validationFuture.asStream().listen(
        (errorMsg) {
          stateStore.setIsAsyncValidating(isAsyncValidating: false);
          if (stateStore.state.isValid) { 
            stateStore.setValidation(
              isValid: errorMsg == null,
              errorMsg: errorMsg,
            );
          }
        },
        onError: (e) {
          stateStore.setIsAsyncValidating(isAsyncValidating: false);
          stateStore.setValidation(
              isValid: false,
              errorMsg: 'Async validation failed: ${e.toString()}');
        },
      );
    });
  }

  @override
  Future<void> flushValidation(
    P value,
    List<IAsyncValidator<P>> validators,
    FieldStateStore stateStore,
  ) async {
    cancel(); // Cancela cualquier validación debounced o en curso
    if (validators.isEmpty) {
      stateStore.setIsAsyncValidating(isAsyncValidating: false);
      return;
    }
    
    // Ejecuta la validación inmediatamente
    stateStore.setIsAsyncValidating(isAsyncValidating: true);
    
    try {
      final String? errorMsg = await _aggregateAsyncValidation(value, validators);
      
      // Solo actualizamos el estado de async si el estado síncrono sigue siendo válido.
      if (stateStore.state.isValid) {
        stateStore.setValidation(
          isValid: errorMsg == null,
          errorMsg: errorMsg,
        );
      }
    } catch (e) {
      // Manejo de errores de ejecución de Future.
      stateStore.setValidation(
          isValid: false,
          errorMsg: 'Async validation failed: ${e.toString()}');
    } finally {
      stateStore.setIsAsyncValidating(isAsyncValidating: false);
    }
  }
  
  Future<String?> _aggregateAsyncValidation(
      P value, List<IAsyncValidator<P>> validators) async {
    for (final validator in validators) {
      final result = await validator.validate(value);
      if (result != null) {
        return result; 
      }
    }
    return null;  
  }

  @override
  void cancel() {
    _debounceTimer?.cancel();
    _validationSubscription?.cancel();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _validationSubscription?.cancel();
  }
}