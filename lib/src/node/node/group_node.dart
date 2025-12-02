import 'package:formkit/src/config/contracts/i_form_schema.dart';
import 'package:formkit/src/node/contracts/i_node_visitor.dart';
import 'package:formkit/src/node/contracts/i_form_container_node.dart';
import 'package:formkit/src/node/contracts/i_form_node.dart';
import 'package:formkit/src/state/state/group_state_store.dart';

class GroupNode implements IFormNode, IFormContainerNode {
  @override
  String name;
  IFormNode? parent;
  @override
  final List<IFormNode> children;
  final GroupStateStore stateStore;
  final IFormSchema _config;
  @override
  IFormSchema get config => _config;

  GroupNode({
    required this.name,
    required IFormSchema config, 
    required this.children,
    required this.stateStore,
    this.parent,
  }) : _config = config; 

  @override
  void setParent(IFormNode? parent) {
    this.parent = parent;
  }

  @override
  void accept(INodeVisitor visitor) {
    visitor.visitGroupNode(this);
  }

  @override
  void dispose() {
    for (var child in children) {
      child.dispose();
    }
    stateStore.dispose();
  }
}
