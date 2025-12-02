import 'package:formkit/src/mapping/contracts/i_data_accessor.dart';
import 'package:formkit/src/node/contracts/i_node_visitor.dart';

abstract interface class IFormHydratorVisitor implements INodeVisitor {
  void setDataSource<TEntity>(TEntity entity, IDataAccessor<TEntity> accessor);
}