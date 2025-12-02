import 'package:formkit/src/core/contracts/i_disposable.dart';
import 'package:formkit/src/node/contracts/i_form_node.dart';

abstract interface class IReactiveEngine<TEntity> implements IDisposable {
  Stream<IFormNode> init(IFormNode rootNode);
  bool evaluateRule(bool Function(TEntity entity) rule);
}