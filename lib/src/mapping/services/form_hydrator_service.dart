import 'package:formkit/src/mapping/contracts/i_data_accessor.dart';
import 'package:formkit/src/node/contracts/i_form_node.dart';
import 'package:formkit/src/mapping/contracts/i_form_tree_hydration.dart';
import 'package:formkit/src/core/engine/node_walker.dart';
import 'package:formkit/src/mapping/visitor/form_hydrator_visitor.dart';

class FormHydratorService implements IFormTreeHydration {
  final NodeWalker _walker;

  FormHydratorService(this._walker);

  @override
  void hydrate<TEntity>(
    IFormNode rootNode,
    TEntity entity,
    IDataAccessor<TEntity> accessor,
  ) {
    final visitor = FormHydratorVisitor<TEntity>();

    visitor.setDataSource(
        entity, accessor, _walker);  
    _walker.walk(rootNode, visitor);
  }
}