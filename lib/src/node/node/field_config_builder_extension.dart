import 'package:formkit/src/validation/contract/i_async_validator_service.dart';
import 'package:formkit/src/reactive/contract/i_reactive_engine.dart';
import 'package:formkit/src/config/models/field_config.dart';
import 'package:formkit/src/node/node/field_node.dart';
import 'package:formkit/src/node/orchestrator/field_orchestrator.dart';
import 'package:formkit/src/state/state/field_state_store.dart';

extension FieldConfigBuilderExtension<P, V> on FieldConfig<P, V> {
  FieldNode<P, V> createTypedNode({
    required String name,
    required Map<String, FieldOrchestrator<dynamic, dynamic>> orchestrators,
    required IAsyncValidatorService<P> asyncValidatorService,
    required IReactiveEngine reactiveEngine,
  }) {
    final stateStore = FieldStateStore<P, V>(
      config: this,
      initialRawValue: initialValue,
      converter: valueConverter,
    );
    final orchestrator = FieldOrchestrator<P, V>(
      fieldName: name,
      valueConverter: valueConverter,
      interceptors: interceptors,
      config: this,
      stateStore: stateStore,
      validators: validators,
      asyncValidators: asyncValidators,
      initialRawValue: initialValue,
      asyncValidatorService: asyncValidatorService,
      reactiveEngine: reactiveEngine,
    );
    orchestrators[name] = orchestrator;

    return FieldNode<P, V>(
      name: name,
      config:
          this, 
      orchestrator: orchestrator,
      stateStore: stateStore,
    );
  }
}
