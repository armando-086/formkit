import 'package:formkit/src/config/contracts/i_form_schema.dart';
import 'package:formkit/src/core/contracts/i_disposable.dart';
import 'package:formkit/src/node/contracts/i_node_visitor.dart';
import 'package:formkit/src/node/contracts/i_form_node.dart';
import 'package:formkit/src/node/orchestrator/field_orchestrator.dart';
import 'package:formkit/src/state/state/field_state_store.dart';

//. =============================================================
//. Representación del nodo de campo (hoja) en el árbol del formulario.
//. P: Tipo Primitivo de entrada (Input).
//. V: Tipo de Valor Final procesado (Output).
//. =============================================================
class FieldNode<P, V> implements IFormNode, IDisposable {
  @override
  String name;
  final FieldOrchestrator<P, V> orchestrator;
  final FieldStateStore<P, V> stateStore;
  final IFormSchema _config;
  @override
  IFormSchema get config => _config;

  IFormNode? parent;

  @override
  void setParent(IFormNode? parent) {
    this.parent = parent;
  }

  FieldNode({
    required this.name,
    required IFormSchema config,
    required this.orchestrator,
    required this.stateStore,
  }) : _config = config;

  FieldOrchestrator<P, V> get fieldOrchestrator => orchestrator;

  @override
  void accept(INodeVisitor visitor) {
    visitor.visitFieldNode(this);
  }

  @override
  void dispose() {
    orchestrator.dispose();
  }
}
