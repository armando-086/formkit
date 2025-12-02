import 'package:formkit/src/node/orchestrator/field_orchestrator.dart';
import 'package:formkit/src/ui/contracts/i_field_binder.dart';

class FieldBinder<P, V> implements IFieldBinder {
  @override
  final String name;
  final FieldOrchestrator<P, V> _orchestrator;

  FieldBinder({
    required this.name,
    required FieldOrchestrator<P, V> orchestrator,
  }) : _orchestrator = orchestrator;

  @override
  void setErrorMsg(String? msg) {
    _orchestrator.stateStore.setValidation(
      isValid: msg == null,
      errorMsg: msg,
    );
  }

  @override
  dynamic getCurrentRawValue() {
    return _orchestrator.rawValue;
  }

  @override
  void dispose() {}
}
