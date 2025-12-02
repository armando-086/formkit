import 'package:formkit/src/node/contracts/i_list_node_creator.dart';
import 'package:formkit/src/config/models/group_config.dart';
import 'package:formkit/src/node/node/group_node.dart';
import 'package:formkit/src/node/contracts/i_form_node.dart';
import 'package:formkit/src/state/state/group_state_store.dart';

class BasicListNodeFactory implements IListNodeCreator {
  @override
  GroupNode createItem({
    required int index,
    required String name,
    dynamic initialValue,
  }) {
    final GroupConfig groupConfig = GroupConfig(name: name, fields: {});
    final GroupStateStore stateStore = GroupStateStore(config: groupConfig);
    final List<IFormNode> children = [];

    return GroupNode(
      name: name,
      config: groupConfig, 
      children: children,
      stateStore: stateStore,
    );
  }
}
