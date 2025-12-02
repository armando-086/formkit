import 'package:formkit/src/config/models/list_config.dart';
import 'package:formkit/src/state/contracts/i_state.dart';

class ListState implements IState {
  @override
  final ListConfig config;
  @override
  final bool isDirty;
  @override
  final bool isTouched; 
  @override
  final bool isValid;
  final List<IState> items; 
  @override
  final String? errorMsg;

  ListState({
    required this.config, 
    required this.items,
    this.isDirty = false,
    this.isTouched = false,
    this.isValid = true,
    this.errorMsg, 
  });

  ListState copyWith({
    bool? isDirty,
    bool? isTouched, 
    bool? isValid,
    List<IState>? items,
    String? errorMsg,
  }) {
    return ListState(
      config: config,
      items: items ?? this.items,
      isDirty: isDirty ?? this.isDirty,
      isTouched: isTouched ?? this.isTouched,
      isValid: isValid ?? this.isValid,
      errorMsg: errorMsg ?? this.errorMsg, 
    );
  }
}
