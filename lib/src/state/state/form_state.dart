import 'package:formkit/src/config/contracts/i_form_schema.dart';
import 'package:formkit/src/state/contracts/i_state.dart';

class FormStates implements IState {
  @override
  final bool isDirty;
  @override
  final bool isTouched;
  @override
  final bool isValid;
  @override
  final IFormSchema config;
  @override
  final String? errorMsg; 

  FormStates({
    required this.config,
    this.isDirty = false,
    this.isTouched = false,
    this.isValid = true,
    this.errorMsg,
  });
  
  FormStates copyWith({
    bool? isDirty,
    bool? isTouched,
    bool? isValid,
    String? errorMsg, 
  }) {
    return FormStates(
      config: config,
      isDirty: isDirty ?? this.isDirty,
      isTouched: isTouched ?? this.isTouched,
      isValid: isValid ?? this.isValid,
      errorMsg: errorMsg ?? this.errorMsg, 
    );
  }
}
