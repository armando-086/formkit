import 'package:formkit/src/validation/contract/i_async_validator_service.dart';
import 'package:formkit/src/core/contracts/i_disposable.dart';
import 'package:formkit/src/node/contracts/i_list_node_creator.dart';
import 'package:formkit/src/reactive/contract/i_reactive_engine.dart';
import 'package:formkit/src/exceptions/formkit_structure_exception.dart';
import 'package:formkit/src/config/models/field_config.dart';
import 'package:formkit/src/config/contracts/i_form_schema.dart';
import 'package:formkit/src/config/models/group_config.dart';
import 'package:formkit/src/config/models/list_config.dart';
import 'package:formkit/src/node/node/field_config_builder_extension.dart';
import 'package:formkit/src/node/node/field_node.dart';
import 'package:formkit/src/node/node/group_node.dart';
import 'package:formkit/src/node/contracts/i_form_node.dart';
import 'package:formkit/src/node/node/list_node.dart';
import 'package:formkit/src/node/orchestrator/field_orchestrator.dart';
import 'package:formkit/src/state/state/group_state_store.dart';
import 'package:formkit/src/state/state/list_state_store.dart';
import 'package:formkit/src/node/node/basic_list_node_factory.dart';

//. =============================================================
//. Constructor del árbol de nodos a partir de un FormSchema.
//. Mantiene el registro de los Orchestrators.
//. =============================================================
class SchemaBuilder implements IDisposable {
  final Map<String, FieldOrchestrator<dynamic, dynamic>> _orchestrators = {};
  final IAsyncValidatorService<dynamic> _asyncValidatorService;
  final IReactiveEngine _reactiveEngine;

  SchemaBuilder({
    required IAsyncValidatorService<dynamic> asyncValidatorService,
    required IReactiveEngine reactiveEngine,
  })  : _asyncValidatorService = asyncValidatorService,
        _reactiveEngine = reactiveEngine;

  IFormNode build(IFormSchema schema, {IFormNode? parent}) {
    final GroupStateStore groupStore = GroupStateStore(config: schema);
    final rootNode = GroupNode(
      name: schema.name,
      config: schema, 
      parent: parent,
      children: [],
      stateStore: groupStore,
    );

    rootNode.children.addAll(schema.fields.entries.map((entry) {
      final name = entry.key;
      final config = entry.value;

      final IFormNode child;

      if (config is FieldConfig) {
        final node = (config as FieldConfig<Object?, Object?>).createTypedNode(
          name: name,
          orchestrators: _orchestrators,
          asyncValidatorService:
              _asyncValidatorService as IAsyncValidatorService<Object?>,
          reactiveEngine: _reactiveEngine,
        );
        child = node;
        groupStore.registerChildStateStream(
            name, (child as FieldNode).stateStore.stateStream);
      } else if (config is GroupConfig) {
        child = build(config, parent: rootNode);
        groupStore.registerChildStateStream(
            name, (child as GroupNode).stateStore.stateStream);
      } else if (config is ListConfig) {
        child = _buildListNode(name, config,
            parent: rootNode, itemFactory: BasicListNodeFactory());
        groupStore.registerChildStateStream(
            name, (child as ListNode).stateStore!.stateStream);
      } else {
        throw FormKitStructureException(
            'Invalid configuration type for field "$name".');
      }

      child.setParent(rootNode);
      return child;
    }));

    return rootNode;
  }

  ListNode _buildListNode(String name, ListConfig config,
      {required IFormNode parent, required IListNodeCreator itemFactory}) {
    // 1. Crear un ListNode placeholder
    final listNodePlaceholder = ListNode(
      name: name,
      config: config,
      children: [],
      stateStore: null,
      parent: parent,
      itemFactory: itemFactory,
    );

    final ListStateStore stateStore = ListStateStore(
      config: config,
      node: listNodePlaceholder,
    );
    return listNodePlaceholder.copyWith(stateStore: stateStore);
  }

  @override
  void dispose() {
    for (var orchestrator in _orchestrators.values) {
      orchestrator.dispose();
    }
    _orchestrators.clear();
  }
}
