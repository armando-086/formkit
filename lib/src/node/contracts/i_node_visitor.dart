import 'package:formkit/src/node/node/field_node.dart';
import 'package:formkit/src/node/node/group_node.dart';
import 'package:formkit/src/node/node/list_node.dart';

abstract interface class INodeVisitor {
  void visitFieldNode<P, V>(FieldNode<P, V> node);
  void visitGroupNode(GroupNode node); 
  void visitListNode(ListNode node); 
}