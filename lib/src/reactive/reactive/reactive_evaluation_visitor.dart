import 'package:formkit/src/node/contracts/i_form_node.dart';
import 'package:formkit/src/node/contracts/i_node_visitor.dart';
import 'package:formkit/src/node/node/field_node.dart';
import 'package:formkit/src/node/node/group_node.dart';
import 'package:formkit/src/node/node/list_node.dart';
import 'package:formkit/src/reactive/engine/reactive_engine.dart';
import 'package:rxdart/subjects.dart';

class ReactiveEvaluationVisitor implements INodeVisitor {
  final PublishSubject<IFormNode> _nodeUpdateSubject;
  final ReactiveEngine _engine; // ignore: unused_field

  ReactiveEvaluationVisitor(this._nodeUpdateSubject, this._engine);

  @override
  void visitFieldNode<P, V>(FieldNode<P, V> node) {
    final config = node.orchestrator.config;

    if (config.enableIf != null || config.isVisibleIf != null) {
      _nodeUpdateSubject.add(node);
    }
  }

  @override
  void visitGroupNode(GroupNode node) {
    for (var child in node.children) {
      child.accept(this);
    }
  }

  @override
  void visitListNode(ListNode node) {
    for (var child in node.children) {
      child.accept(this);
    }
  }
}