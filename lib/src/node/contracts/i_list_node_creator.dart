import 'package:formkit/src/node/node/group_node.dart';

abstract interface class IListNodeCreator {
  GroupNode createItem({
    required int index,
    required String name,
    dynamic initialValue,
  });
}
