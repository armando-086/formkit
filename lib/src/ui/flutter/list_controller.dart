import 'package:formkit/src/ui/contracts/i_list_controller.dart';
import 'package:formkit/src/node/node/list_node.dart';
import 'package:formkit/src/state/state/list_state.dart';
import 'package:formkit/src/core/engine/node_walker.dart';

class ListController<TItem> implements IListController<TItem> {
  final ListNode _node;
  final NodeWalker _walker; 
  
  ListController(this._node, this._walker); 

  @override
  Stream<ListState> get stateStream => _node.stateStore!.stream;

  @override
  void addItem({TItem? initialValue}) {
    final int newIndex = _node.children.length;  
    final String itemName = '${_node.name}[$newIndex]';
    final newGroupNode = _node.itemFactory.createItem(
      index: newIndex,
      name: itemName,
      initialValue: initialValue,
    );

    _walker.addChild(_node, newGroupNode);  
  }

  @override
  void removeItem(int index) {
    _walker.removeChildAt(_node, index);
  }

  @override
  void clear() {
    _walker.clearChildren(_node);
  }

  @override
  void dispose() {
  }
}