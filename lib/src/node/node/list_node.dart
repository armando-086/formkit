import 'package:formkit/src/config/contracts/i_form_schema.dart';
import 'package:formkit/src/node/contracts/i_list_node_creator.dart';
import 'package:formkit/src/node/contracts/i_node_visitor.dart';
import 'package:formkit/src/node/contracts/i_form_container_node.dart';
import 'package:formkit/src/node/contracts/i_form_node.dart';
import 'package:formkit/src/state/state/list_state_store.dart';

class ListNode implements IFormNode, IFormContainerNode {
  @override
  final String name;
  IFormNode? parent;

  final List<IFormNode> _children;
  @override
  List<IFormNode> get children => List.unmodifiable(_children);
  List<IFormNode> get mutableChildren => _children;
  final IFormSchema _config;
  @override
  IFormSchema get config => _config;

  final ListStateStore? stateStore;
  final IListNodeCreator itemFactory;

  ListNode({
    required this.name,
    required IFormSchema config, 
    required List<IFormNode> children,
    required this.stateStore,
    required this.itemFactory,
    this.parent,
  })  : _children = children,
        _config = config 
  {
    for (var child in _children) {
      child.setParent(this);
    }
  }

  ListNode copyWith({
    String? name,
    IFormNode? parent,
    List<IFormNode>? children,
    ListStateStore? stateStore,
    IListNodeCreator? itemFactory,
    IFormSchema? config, 
  }) {
    return ListNode(
      name: name ?? this.name,
      parent: parent ?? this.parent,
      children: children ?? _children,
      stateStore: stateStore ?? this.stateStore,
      itemFactory: itemFactory ?? this.itemFactory,
      config: config ?? _config, 
    );
  }

  @override
  void setParent(IFormNode? parent) {
    this.parent = parent;
  }

  @override
  void accept(INodeVisitor visitor) {
    visitor.visitListNode(this);
  }

  @override
  void dispose() {
    for (var child in _children) {
      child.dispose();
    }
    stateStore?.dispose();
  }
}
