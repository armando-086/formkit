import 'package:formkit/src/exceptions/formkit_node_not_found_exception.dart';
import 'package:formkit/src/node/node/group_node.dart';
import 'package:formkit/src/node/contracts/i_form_node.dart';
import 'package:formkit/src/node/node/list_node.dart';
//. =============================================================
//. Utilidad para encontrar nodos dentro del árbol IFormNode (recorrido no-Visitor).
//. =============================================================
class NodeFinder {
  NodeFinder();

  IFormNode findNode(String name, IFormNode rootNode) {
    IFormNode? found;

    void recursiveFind(IFormNode node) {
      if (node.name == name) {
        found = node;
        return;
      }

      if (found != null) return;
      if (node is GroupNode) {
        for (var child in (node.children is Map ? (node.children as Map).values : node.children)) {
          recursiveFind(child as IFormNode);
          if (found != null) return; 
        }
      } else if (node is ListNode) {
        for (var child in node.children) {
          recursiveFind(child);
          if (found != null) return;
        }
      }
    }

    recursiveFind(rootNode);
    if (found == null) {
      throw FormKitNodeNotFoundException(name);
    }
    return found!;
  }
}
