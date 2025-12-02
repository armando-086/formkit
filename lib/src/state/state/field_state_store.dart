import 'package:formkit/src/core/contracts/i_disposable.dart';
import 'package:formkit/src/state/contracts/i_form_state_store.dart';
import 'package:formkit/src/mapping/contracts/i_value_converter.dart';
import 'package:formkit/src/config/models/field_config.dart';
import 'package:formkit/src/state/state/field_state.dart';
import 'package:rxdart/subjects.dart';
//. =============================================================
//. BehaviorSubject que gestiona y emite el estado y el valor de un campo.
//. P: Tipo Primitivo (valor de entrada del widget).
//. V: Tipo de Valor Final (valor procesado por el orchestrator).
//. =============================================================

class FieldStateStore<P, V>
    implements IFormStateStore<FieldState>, IDisposable {
  final FieldConfig<P, V> config;
  final BehaviorSubject<FieldState> _stateSubject;

  FieldStateStore({
    required this.config,
    required P? initialRawValue,
    required IValueConverter<P, V> converter,
  }) : _stateSubject = BehaviorSubject<FieldState>.seeded(
          FieldState(config: config),
        );

  @override
  FieldState get state => _stateSubject.value;

  Stream<FieldState> get stateStream => _stateSubject.stream;

  @override
  Stream<FieldState> get stream => _stateSubject.stream;

  void setIsDirty({required bool isDirty}) {
    _stateSubject.add(state.copyWith(
      isDirty: isDirty,
    ));
  }

  void setIsTouched({required bool isTouched}) {
    _stateSubject.add(state.copyWith(
      isTouched: isTouched,
    ));
  }

  void setIsAsyncValidating({required bool isAsyncValidating}) {
    _stateSubject.add(state.copyWith(
      isAsyncValidating: isAsyncValidating,
    ));
  }

  void setValidation({required bool isValid, String? errorMsg}) {
    _stateSubject.add(state.copyWith(
      isValid: isValid,
      errorMsg: errorMsg,
    ));
  }

  @override
  void reset() {
    _stateSubject.add(FieldState(config: config));
  }

  @override
  void dispose() {
    _stateSubject.close();
  }
}
