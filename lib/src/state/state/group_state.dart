import 'package:formkit/src/config/contracts/i_form_schema.dart';
import 'package:formkit/src/state/contracts/i_state.dart';

class GroupState implements IState {
  @override
  final IFormSchema config;
  @override
  final bool isDirty;
  @override
  final bool isTouched;
  @override
  final bool isValid;
  @override
  final String? errorMsg;

  GroupState({
    required this.config, 
    this.isDirty = false,
    this.isTouched = false,
    this.isValid = true,
    this.errorMsg, 
  });

  GroupState copyWith({
    bool? isDirty,
    bool? isTouched, 
    bool? isValid,
    String? errorMsg, 
  }) {
    return GroupState(
      config: config,
      isDirty: isDirty ?? this.isDirty,
      isTouched: isTouched ?? this.isTouched,
      isValid: isValid ?? this.isValid,
      errorMsg: errorMsg ?? this.errorMsg, 
    );
  }
}
