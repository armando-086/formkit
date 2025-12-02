import 'package:formkit/src/exceptions/formkit_exeption.dart';
import 'package:formkit/src/exceptions/formkit_structure_exception.dart';
import 'package:formkit/src/node/node/field_node.dart';
import 'package:formkit/src/node/node/group_node.dart';
import 'package:formkit/src/node/node/list_node.dart';
import 'package:formkit/src/mapping/contracts/i_form_mapper_visitor.dart';
//. =============================================================
//. Implementación del Visitor que realiza el mapeo (Map) de los nodos.
//. Simula el código que sería generado por formkit_generator.
//. =============================================================

class FormMapperVisitor implements IFormMapperVisitor {
  final List<dynamic> _mapStack = [];

  FormMapperVisitor();

  @override
  void visitFieldNode<P, V>(FieldNode<P, V> node) {
    final V finalValue = node.orchestrator.finalValue;

    if (_mapStack.isEmpty) {
      throw FormKitStructureException(
          'FieldNode "${node.name}" visited without a parent container on the stack.');
    }

    final currentContainer = _mapStack.last;

    if (currentContainer is Map<String, dynamic>) {
      currentContainer[node.name] = finalValue;
    } else {
      throw FormKitStructureException(
          'FieldNode "${node.name}" visited under a non-Map container.');
    }
  }

  @override
  void visitGroupNode(GroupNode node) {
    if (_mapStack.isEmpty) {
      _mapStack.add(<String, dynamic>{});
      return;
    }

    final Map<String, dynamic> newMap = {};
    final parentContainer = _mapStack.last;

    if (parentContainer is Map<String, dynamic>) {
      parentContainer[node.name] = newMap;
    } else if (parentContainer is List<dynamic>) {
      parentContainer.add(newMap);
    } else {
      throw FormKitStructureException(
          'Parent container for GroupNode "${node.name}" is neither a Map nor a List.');
    }

    _mapStack.add(newMap);
  }

  @override
  void visitListNode(ListNode node) {
    final List<dynamic> newList = [];

    if (_mapStack.isEmpty || _mapStack.last is! Map<String, dynamic>) {
      throw FormKitStructureException(
          'ListNode "${node.name}" must be nested under a GroupNode (Map) on the stack.');
    }

    final parentContainer = _mapStack.last as Map<String, dynamic>;
    parentContainer[node.name] = newList;
    _mapStack.add(newList);
  }

  void pop() {
    if (_mapStack.length > 1) {
      _mapStack.removeLast();
    }
  }

  @override
  TOutputVO getMapResult<TOutputVO>() {
    if (_mapStack.length != 1 || _mapStack.first is! Map) {
      throw FormKitException(
          'Mapping failed: Result stack is malformed or root object not created. Stack length: ${_mapStack.length}');
    }

    final Map<String, dynamic> rootMap = _mapStack.first;

    if (TOutputVO == Map || TOutputVO == Map<String, dynamic>) {
      return rootMap as TOutputVO;
    }

    throw UnimplementedError(
        'Automatic mapping to type "$TOutputVO" is not supported by default. For types other than Map<String, dynamic>, you must use the @FormKitMapper code generation tool or provide a custom IFormMapper<TOutputVO> implementation.');
  }
}