import 'dart:async';
import 'package:formkit/src/reactive/reactive/node_finder_visitor.dart';
import 'package:formkit/src/reactive/reactive/reactive_evaluation_visitor.dart';
import 'package:rxdart/rxdart.dart';
import 'package:formkit/src/core/contracts/i_disposable.dart';
import 'package:formkit/src/core/contracts/i_form_controller.dart';
import 'package:formkit/src/reactive/contract/i_reactive_engine.dart';
import 'package:formkit/src/node/node/field_node.dart';
import 'package:formkit/src/node/contracts/i_form_node.dart';
import 'package:formkit/src/core/engine/node_walker.dart';

class ReactiveEngine<TEntity> implements IReactiveEngine<TEntity>, IDisposable {
  final NodeWalker _walker;
  final IFormController<TEntity> _formController; 
  IFormNode? _rootNode; 
  final _nodeUpdateSubject = PublishSubject<IFormNode>();
  StreamSubscription<dynamic>? _stateSubscription;
  ReactiveEngine(this._walker, this._formController);

  @override
  Stream<IFormNode> init(IFormNode rootNode) {
    _rootNode = rootNode;

    final nodeFinder = NodeFinderVisitor<FieldNode<dynamic, dynamic>>();
    _walker.walk(rootNode, nodeFinder);
    final fieldNodes = nodeFinder.foundNodes.cast<FieldNode>();
    final List<Stream<dynamic>> valueStreams = fieldNodes
        .where((node) =>
            node.orchestrator.config.enableIf != null ||
            node.orchestrator.config.isVisibleIf != null)
        .map((node) => node.orchestrator.rawValueStream)
        .toList();

    _stateSubscription = Rx.merge(valueStreams)
        .debounceTime(const Duration(milliseconds: 50))
        .listen((_) {
      _reEvaluateAllRules(rootNode);
    });

    _reEvaluateAllRules(rootNode);

    return _nodeUpdateSubject.stream;
  }

  void _reEvaluateAllRules(IFormNode rootNode) {
    _walker.walk(
        rootNode, ReactiveEvaluationVisitor(_nodeUpdateSubject, this));
  }

  @override
  bool evaluateRule(bool Function(TEntity entity) rule) {
    if (_rootNode == null) return false;
    final TEntity currentEntity = _formController.toEntity(); 
    return rule(currentEntity);
  }

  @override
  void dispose() {
    _stateSubscription?.cancel();
    _nodeUpdateSubject.close();
  }
}