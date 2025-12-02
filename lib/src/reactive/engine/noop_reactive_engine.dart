import 'dart:async';
import 'package:formkit/src/reactive/contract/i_reactive_engine.dart';
import 'package:formkit/src/node/contracts/i_form_node.dart';

/// Implementación no-operativa por defecto de `IReactiveEngine`.

class NoopReactiveEngine<TEntity> implements IReactiveEngine<TEntity> {
  NoopReactiveEngine();

  @override
  Stream<IFormNode> init(IFormNode rootNode) {
    //. Devuelve un stream que no emite nada.
    return const Stream<IFormNode>.empty();
  }

  @override
  bool evaluateRule(bool Function(TEntity entity) rule) {
    //. No se puede evaluar reglas sin un formulario; devolver false por defecto.
    return false;
  }

  @override
  void dispose() {
    // No-op
  }
}
