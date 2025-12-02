import 'dart:async';
import 'package:formkit/src/reactive/contract/i_reactive_engine.dart';
import 'package:formkit/src/node/contracts/i_form_node.dart';

class FakeReactiveEngine<TEntity> implements IReactiveEngine<TEntity> {
  //. Propiedad para controlar el resultado de evaluateRule en las pruebas
  bool evaluationResult = true;

  @override
  Stream<IFormNode> init(IFormNode rootNode) {
    //. En un Fake, el init no hace nada real, solo retorna un stream vacío
    //. para cumplir el contrato sin necesidad de subscriptions complejas.
    return Stream.empty();
  }

  @override
  bool evaluateRule(bool Function(TEntity entity) rule) {
    //. El Fake ignora la lógica de la función 'rule' y retorna el valor de simulación.
    return evaluationResult;
  }

  @override
  void dispose() {
    // No-op
  }
}