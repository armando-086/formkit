import 'package:formkit/src/node/contracts/i_form_node.dart';
import 'package:formkit/src/node/contracts/i_node_visitor.dart';
import 'package:formkit/src/node/node/field_node.dart';
import 'package:formkit/src/node/node/group_node.dart';
import 'package:formkit/src/node/node/list_node.dart';

class NodeFinderVisitor<T extends IFormNode> implements INodeVisitor {
  final List<T> foundNodes = [];

  @override
  void visitFieldNode<P, V>(FieldNode<P, V> node) {
    if (node is T) {
      foundNodes.add(node
          as T);  
    }
  }

  @override
  void visitGroupNode(GroupNode node) {
    if (node is T) {
      foundNodes.add(node as T);  
    }
    for (var child in node.children) {
      child.accept(this);
    }
  }

  @override
  void visitListNode(ListNode node) {
    if (node is T) {
      foundNodes.add(node as T);  
    }
    for (var child in node.children) {
      child.accept(this);
    }
  }
}