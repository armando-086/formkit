import 'package:formkit/src/mapping/contracts/i_data_accessor.dart';
import 'package:formkit/src/node/contracts/i_form_node.dart';

abstract interface class IFormTreeHydration {
  void hydrate<TEntity>(
      IFormNode rootNode, TEntity entity, IDataAccessor<TEntity> accessor);
}