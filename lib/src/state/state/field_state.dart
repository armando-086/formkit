import 'package:formkit/src/config/contracts/i_form_schema.dart';
import 'package:formkit/src/state/contracts/i_state.dart';

class FieldState<P, V> implements IState {
  @override
  final bool isValid;
  @override
  final bool isDirty;
  @override
  final bool isTouched;
  @override
  final String? errorMsg;
  @override
  final IFormSchema config;

  final bool
      isAsyncValidating;

  FieldState({
    required this.config,
    this.isValid = true,
    this.isDirty = false,
    this.isTouched = false,
    this.errorMsg,
    this.isAsyncValidating = false, 
  });

  FieldState<P, V> copyWith({
    bool? isValid,
    bool? isDirty,
    bool? isTouched,
    String? errorMsg,
    bool?
        isAsyncValidating, 
  }) {
    return FieldState<P, V>(
      config: config,
      isValid: isValid ?? this.isValid,
      isDirty: isDirty ?? this.isDirty,
      isTouched: isTouched ?? this.isTouched,
      errorMsg: errorMsg,
      isAsyncValidating:
          isAsyncValidating ?? this.isAsyncValidating,
    );
  }
}
