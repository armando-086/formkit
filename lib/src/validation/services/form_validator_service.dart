import 'package:formkit/src/node/contracts/i_node_visitor.dart';
import 'package:formkit/src/node/node/field_node.dart';
import 'package:formkit/src/node/node/group_node.dart';
import 'package:formkit/src/node/node/list_node.dart';
import 'package:formkit/src/validation/contract/i_form_validator_service.dart';
import 'package:formkit/src/validation/contract/i_form_validator_visitor.dart';
import 'package:formkit/src/exceptions/fomkit_validation_exeption.dart';
import 'package:formkit/src/node/contracts/i_form_node.dart';
import 'package:formkit/src/core/engine/node_walker.dart';
import 'package:formkit/src/validation/visitor/basic_form_validator_visitor.dart';

//. =============================================================
//. Implementación concreta del IFormValidator.
//. Recorre el árbol y lanza FormKitValidationException si falla.
//. =============================================================
class FormValidatorService implements IFormValidatorService {
  final NodeWalker _walker;
  final IFormValidatorVisitor _validatorVisitor;

  FormValidatorService(this._walker, this._validatorVisitor);

  @override
  void dispose() {}

  @override
  Map<String, String> getErrors(IFormNode rootNode) {
    // Asumiendo que BasicFormValidatorVisitor es la implementación real de IFormValidatorVisitor
    (_validatorVisitor as BasicFormValidatorVisitor).reset(); 
    _walker.walk(rootNode, _validatorVisitor);
    return _validatorVisitor.errors;
  }

  @override
  bool validate(IFormNode rootNode) {
    (_validatorVisitor as BasicFormValidatorVisitor).reset();
    _walker.walk(rootNode, _validatorVisitor);

    if (!_validatorVisitor.formIsValid) {
      throw FormKitValidationException(
        message: 'Form validation failed.',
        errors: _validatorVisitor.errors,
      );
    }
    return true;
  }
  
  // -------------------------------------------------------------
  // 2. IMPLEMENTACIÓN del nuevo método: runAllAsyncValidation
  // -------------------------------------------------------------
  @override
  Future<void> runAllAsyncValidation(IFormNode rootNode) async {
    final collector = _AsyncValidationCollectorVisitor();
    
    // Recorre el árbol y ejecuta la validación asíncrona en cada campo
    _walker.walk(rootNode, collector);
    
    // Espera a que todos los futuros de validación asíncrona finalicen.
    await collector.awaitAll();
  }
}

// -------------------------------------------------------------
// 1. Visitor auxiliar para recolectar futuros de validación asíncrona
// -------------------------------------------------------------
class _AsyncValidationCollectorVisitor implements INodeVisitor {
  final List<Future<void>> _validationFutures = [];

  @override
  void visitFieldNode<P, V>(FieldNode<P, V> node) {
    // Asumiendo que el orquestador del campo tiene un método para forzar 
    // la validación asíncrona y devuelve un Future.
    _validationFutures.add(node.orchestrator.runAsyncValidation());
  }

  @override
  void visitGroupNode(GroupNode node) {}

  @override
  void visitListNode(ListNode node) {}

  Future<void> awaitAll() => Future.wait(_validationFutures);
}
