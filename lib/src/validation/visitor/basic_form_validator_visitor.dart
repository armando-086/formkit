import 'package:formkit/src/validation/contract/i_form_validator_visitor.dart';
import 'package:formkit/src/node/node/field_node.dart';
import 'package:formkit/src/node/node/group_node.dart';
import 'package:formkit/src/node/node/list_node.dart';
//. =============================================================
//. Implementación del Visitor de Validación (Formalización del Core)
//. =============================================================

class BasicFormValidatorVisitor implements IFormValidatorVisitor {
  final Map<String, String> _errors = {};
  bool _formIsValid = true;

  @override
  bool get formIsValid => _formIsValid;

  @override
  Map<String, String> get errors => Map.unmodifiable(_errors);

  @override
  void visitFieldNode<P, V>(FieldNode<P, V> node) {
    node.orchestrator.validate(triggerAsync: false);
    if (!node.stateStore.state.isValid) {
      _formIsValid = false;
      if (node.stateStore.state.errorMsg != null) {
        _errors[node.name] = node.stateStore.state.errorMsg!;
      }
    }
  }

  @override
  void visitGroupNode(GroupNode node) {}

  @override
  void visitListNode(ListNode node) {}

  void reset() {
    _errors.clear();
    _formIsValid = true;
  }
}
