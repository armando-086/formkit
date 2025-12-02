import 'package:formkit/src/mapping/contracts/i_data_accessor.dart';
import 'package:formkit/src/node/contracts/i_node_visitor.dart';
import 'package:formkit/src/node/node/field_node.dart';
import 'package:formkit/src/node/node/group_node.dart';
import 'package:formkit/src/node/node/list_node.dart';
import 'package:formkit/src/core/engine/node_walker.dart';

//. =============================================================
//. Implementación del Visitor que realiza la hidratación de los nodos.
//. =============================================================
class FormHydratorVisitor<TEntity> implements INodeVisitor {
  late TEntity _entity;
  late IDataAccessor<TEntity> _accessor;
  late NodeWalker
      _walker;  

  void setDataSource(
      TEntity entity, IDataAccessor<TEntity> accessor, NodeWalker walker) {
    _entity = entity;
    _accessor = accessor;
    _walker = walker;
  }

  @override
  void visitListNode(ListNode node) {
    final List<dynamic>? entityList =
        _accessor.getValue(_entity, node.name) as List<dynamic>?;

    _walker.clearChildren(node);

    if (entityList == null || entityList.isEmpty) {
      return;
    }

    for (int i = 0; i < entityList.length; i++) {
      final listItem = entityList[i];
      final newGroupNode = node.itemFactory.createItem(
        index: i,
        name: '${node.name}[$i]',
        initialValue: listItem,
      );

      _walker.addChild(node, newGroupNode);

      final itemVisitor = FormHydratorVisitor<dynamic>();
      itemVisitor.setDataSource(
          listItem, _accessor as IDataAccessor<dynamic>, _walker);
      _walker.walk(newGroupNode, itemVisitor);
    }
  }

  @override
  void visitGroupNode(GroupNode node) {
    for (var child in node.children) {
      child.accept(this);
    }
  }

  @override
  void visitFieldNode<P, V>(FieldNode<P, V> node) {
    final rawValue = _accessor.getValue(_entity, node.name);
    if (rawValue != null) {
      node.fieldOrchestrator
          .setInitialRawValue(rawValue as P);
    }
  }
}