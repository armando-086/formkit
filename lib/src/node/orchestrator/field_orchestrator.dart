import 'dart:async';
import 'package:formkit/src/validation/contract/i_async_validator.dart';
import 'package:formkit/src/validation/contract/i_async_validator_service.dart';
import 'package:formkit/src/core/contracts/i_disposable.dart';
import 'package:formkit/src/reactive/contract/i_reactive_engine.dart';
import 'package:formkit/src/validation/contract/i_validator.dart';
import 'package:formkit/src/mapping/contracts/i_value_converter.dart';
import 'package:formkit/src/mapping/contracts/i_value_interceptor.dart';
import 'package:formkit/src/exceptions/value_failure_exception.dart';
import 'package:formkit/src/config/models/field_config.dart';
import 'package:formkit/src/state/state/field_state.dart';
import 'package:formkit/src/state/state/field_state_store.dart';
//. =============================================================
//. Orquestador de la lógica de campo: validación, intercepción y estado.
//. Es el punto de control entre la UI y el Core.
//. P: Tipo Primitivo de entrada (Input).
//. V: Tipo de Valor Final procesado (Output).
//. =============================================================
class FieldOrchestrator<P, V> implements IDisposable {
  final String fieldName;
  final List<IValidator<P>> validators;
  final List<IAsyncValidator<P>>
      asyncValidators;
  final IValueConverter<P, V> _valueConverter;
  final List<IValueInterceptor<P, P>> interceptors;
  final FieldStateStore<P, V> stateStore;
  final FieldConfig<P, V> config;
  final IAsyncValidatorService<P> _asyncValidatorService;
  final IReactiveEngine _reactiveEngine; // ignore: unused_field

  P? _rawValue;
  final P? _initialRawValue;

  FieldOrchestrator({
    required this.fieldName,
    required this.validators,
    required this.asyncValidators,
    required IValueConverter<P, V> valueConverter,
    required this.interceptors,
    required this.stateStore,
    required this.config,
    required IAsyncValidatorService<P> asyncValidatorService,
    required IReactiveEngine reactiveEngine,
    P? initialRawValue,
  })  : _valueConverter = valueConverter,
        _initialRawValue = initialRawValue,
        _asyncValidatorService = asyncValidatorService,
        _reactiveEngine = reactiveEngine
  {
    if (initialRawValue != null) {
      _rawValue = initialRawValue;
      _validateAndSetState(_rawValue, isDirty: false);
    }
  }

  P? get rawValue => _rawValue;
  Stream<P?> get rawValueStream =>
      stateStore.stateStream.map((_) => _rawValue).distinct();

  void setInitialRawValue(P rawValue) {
    _rawValue = rawValue;
    _validateAndSetState(_rawValue, isDirty: false);
  }

  void reset() {
    _rawValue = _initialRawValue;
    stateStore.reset();
    _validateAndSetState(_rawValue, isDirty: false, forceUpdate: true);
  }

  @override
  void dispose() {
    stateStore.dispose();
    _asyncValidatorService.dispose();
  }

  void setRawValue(P newValue) {
    if (_rawValue == newValue) return;
    _validateAndSetState(newValue, isDirty: true);
  }

  void validate({bool triggerAsync = false}) {
    _validateAndSetState(_rawValue,
        isDirty: stateStore.state.isDirty, forceUpdate: true, triggerAsync: triggerAsync);
  }

  // . =======================================================================
  // . Nuevo método para forzar la validación asíncrona y esperar su finalización
  // . =======================================================================
  /// Dispara la validación asíncrona del campo inmediatamente, sin debounce,
  /// y devuelve un [Future] que se resuelve cuando la validación ha terminado.
  /// Este método es crucial para el proceso de [validatedFlush].
  Future<void> runAsyncValidation() async {
    final validationResult = _runValidators(_rawValue);

    // 1. Si la validación síncrona falla, no tiene sentido continuar con la asíncrona.
    if (!validationResult.isValid) {
      stateStore.setValidation(
          isValid: false,
          errorMsg: validationResult.errorMsg,
      );
      _asyncValidatorService.cancel();
      stateStore.setIsAsyncValidating(isAsyncValidating: false);
      return;
    }

    // 2. Si es válido y hay validadores asíncronos.
    if (asyncValidators.isNotEmpty) {
      // Usamos el nuevo método 'flushValidation' que ejecuta inmediatamente y espera.
      final P valueToValidate = _rawValue as P; // Se asume que no es null si pasó el required/sync
      await _asyncValidatorService.flushValidation(
          valueToValidate, asyncValidators, stateStore);
    } else {
      // 3. Si no hay validadores async, asegura el estado de async limpio.
      _asyncValidatorService.cancel();
      stateStore.setIsAsyncValidating(isAsyncValidating: false);
    }
  }
  // . =======================================================================

  void _validateAndSetState(P? value,
      {required bool isDirty, bool forceUpdate = false, bool triggerAsync = true}) {

    P? processedValue = value;
    for (final interceptor in interceptors) {
      if (processedValue != null) {
        processedValue = interceptor.intercept(processedValue);
      }
    }

    final bool rawValueChanged = _rawValue != processedValue;
    _rawValue = processedValue;

    if (isDirty) {
      stateStore.setIsDirty(isDirty: true);
      stateStore.setIsTouched(isTouched: true);
    }

    final validationResult = _runValidators(processedValue);

    if (rawValueChanged || forceUpdate) {
      stateStore.setValidation(
        isValid: validationResult.isValid,
        errorMsg: validationResult.errorMsg,
      );
    }

    if (triggerAsync && validationResult.isValid && asyncValidators.isNotEmpty) {
      _asyncValidatorService.validate(value, asyncValidators, stateStore);
    } else {
      _asyncValidatorService.cancel();
      stateStore.setIsAsyncValidating(isAsyncValidating: false);
    }
  }

  // Se mantiene la lógica original para _runValidators
  ({bool isValid, String? errorMsg}) _runValidators(P? value) {
    for (final validator in validators) {
        if (value != null) {
          final result = validator.validate(value);
          if (result != null) {
            return (isValid: false, errorMsg: result);
          }
        }
    }
    return (isValid: true, errorMsg: null);
  }

  V get finalValue {
    if (_rawValue == null && null is! P) {
      throw ValueFailureException(
        fieldName: fieldName,
        valueFailure: 'Value is null and cannot be converted to $V',
        message: 'Value is null and cannot be converted to $V'
      );
    }

    try {
      return _valueConverter.convert(_rawValue as P);
    } on ValueFailureException catch (e) {
      stateStore.setValidation(
          isValid: false, errorMsg: e.message);
      rethrow;
    } catch (e) {
      final errorMsg = 'Failed to convert $P to $V: $e';
      stateStore.setValidation(
          isValid: false, errorMsg: errorMsg);

      throw ValueFailureException(
        fieldName: fieldName,
        valueFailure: errorMsg,
        message: errorMsg,
      );
    }
  }

  Stream<FieldState> get stateStream => stateStore.stateStream;
  FieldState get state => stateStore.state;
}