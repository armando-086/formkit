import 'package:formkit/src/mapping/contracts/i_data_accessor.dart';
import 'package:formkit/src/core/contracts/i_form_tree_management.dart';
import 'package:formkit/src/mapping/contracts/i_form_tree_hydration.dart';
import 'package:formkit/src/mapping/visitor/form_mapper_visitor.dart';
import 'package:formkit/src/node/contracts/i_node_visitor.dart';
import 'package:formkit/src/node/node/field_node.dart';
import 'package:formkit/src/node/node/group_node.dart';
import 'package:formkit/src/node/contracts/i_form_node.dart';
import 'package:formkit/src/node/node/list_node.dart';

//. -----------------------------------------------------------------------------
//. 4.1 Centralización del Recorrido: Implementación del NodeWalker
//. -----------------------------------------------------------------------------
class NodeWalker implements IFormTreeManagement, IFormTreeHydration {
  @override
  void walk(IFormNode rootNode, INodeVisitor visitor) {
    _recursiveWalk(rootNode, visitor);
  }

  void _recursiveWalk(IFormNode node, INodeVisitor visitor) {
    // 1. Pre-Visit (Agregar el contenedor a la pila)
    node.accept(visitor);

    // 2. Recorrido de hijos
    if (node is GroupNode) {
      for (final child in node.children) {
        _recursiveWalk(child, visitor);
      }
    } else if (node is ListNode) {
      for (final child in node.children) {
        _recursiveWalk(child, visitor);
      }
    }

    if (visitor is FormMapperVisitor &&
        (node is GroupNode || node is ListNode)) {
      visitor.pop();
    }
  }

  void addChild(ListNode listNode, IFormNode node) {
    node.setParent(listNode);
    listNode.mutableChildren.add(node);

    final dynamic nodeWithState = node;

    listNode.stateStore?.registerItemState(listNode.mutableChildren.length - 1,
        nodeWithState.stateStore.stream, nodeWithState.stateStore.state);
  }

  void removeChildAt(ListNode listNode, int index) {
    if (index < 0 || index >= listNode.mutableChildren.length) return;

    final removedNode = listNode.mutableChildren.removeAt(index);
    removedNode.dispose();

    listNode.stateStore?.unregisterItemState(index);

    for (int i = index; i < listNode.mutableChildren.length; i++) {
      (listNode.mutableChildren[i] as GroupNode).name = '${listNode.name}[$i]';
    }
  }

  void clearChildren(ListNode listNode) {
    for (var child in listNode.mutableChildren) {
      child.dispose();
    }
    listNode.mutableChildren.clear();
    listNode.stateStore?.reset();
  }

  @override
  void reset(IFormNode rootNode) {
    _recursiveAction(rootNode, (node) {
      if (node is FieldNode) {
        node.orchestrator.reset();
      }
    });
  }

  @override
  void dispose(IFormNode rootNode) {
    _recursiveAction(rootNode, (node) {
      node.dispose();
    });
  }

  @override
  void hydrate<TEntity>(
      IFormNode rootNode, TEntity entity, IDataAccessor<TEntity> accessor) {
    _recursiveAction(rootNode, (node) {
      if (node is FieldNode) {
        final dynamic value = accessor.getValue(entity, node.name);
        if (value != null) {
          node.orchestrator.setInitialRawValue(value);
        }
      }
    });
  }

  IFormNode? findNodeByName(IFormNode rootNode, String name) {
    return _recursiveFind(rootNode, name);
  }

  IFormNode? _recursiveFind(IFormNode node, String name) {
    if (node.name == name) {
      return node;
    }

    if (node is GroupNode) {
      for (final child in node.children) {
        final found = _recursiveFind(child, name);
        if (found != null) return found;
      }
    } else if (node is ListNode) {
      for (final child in node.children) {
        final found = _recursiveFind(child, name);
        if (found != null) return found;
      }
    }
    return null;
  }

  void _recursiveAction(
    IFormNode node,
    void Function(IFormNode node) action,
  ) {
    action(node);

    if (node is GroupNode) {
      for (final child in node.children) {
        _recursiveAction(child, action);
      }
    } else if (node is ListNode) {
      for (final child in node.children) {
        _recursiveAction(child, action);
      }
    }
  }
}
