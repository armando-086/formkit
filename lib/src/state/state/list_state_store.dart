import 'dart:async';
import 'package:formkit/src/core/contracts/i_disposable.dart';
import 'package:formkit/src/state/contracts/i_form_state_store.dart';
import 'package:formkit/src/config/models/list_config.dart';
import 'package:formkit/src/node/node/list_node.dart';
import 'package:formkit/src/state/contracts/i_state.dart';
import 'package:formkit/src/state/state/list_state.dart';
import 'package:formkit/src/state/state/state_aggregator_mixin.dart';
import 'package:rxdart/subjects.dart';

//. =============================================================
//. Almacén de estado que gestiona el estado consolidado de un ListNode.
//. V: Tipo del elemento de la lista (ej. AddressVO).
//. =============================================================
class ListStateStore
    with
        StateAggregatorMixin<ListState> 
    implements
        IFormStateStore<ListState>,
        IDisposable {
  final BehaviorSubject<ListState> _stateSubject;
  @override
  BehaviorSubject<ListState> get stateSubject =>
      _stateSubject; 

  final Map<int, IState> _childStates = {};
  @override
  Map<Object, IState> get childStates => _childStates
      .cast<Object, IState>(); 

  final Map<int, StreamSubscription> _childSubscriptions = {};
  final ListConfig config;

  final ListNode node;

  ListStateStore({
    required this.config,
    required this.node,
    ListState? initialState,
  }) : _stateSubject = BehaviorSubject<ListState>.seeded(
          initialState ?? ListState(config: config, items: []),
        );

  @override
  ListState get state => _stateSubject.value;

  Stream<ListState> get stateStream => _stateSubject.stream;

  @override
  Stream<ListState> get stream => _stateSubject.stream;

  void registerItemState(
      int index, Stream<IState> childStateStream, IState initialState) {
    if (_childSubscriptions.containsKey(index)) {
      _childSubscriptions[index]?.cancel();
    }

    _childStates[index] = initialState;

    _childSubscriptions[index] = childStateStream.listen((state) {
      _childStates[index] = state;
      recalculateState();
    });

    recalculateState();
  }

  void unregisterItemState(int index) {
    _childSubscriptions[index]?.cancel();
    _childSubscriptions.remove(index);
    _childStates.remove(index);
    final List<int> keysToMove =
        _childStates.keys.where((key) => key > index).toList()..sort();

    for (int oldIndex in keysToMove) {
      final newIndex = oldIndex - 1;
      final state = _childStates.remove(oldIndex)!;
      _childStates[newIndex] = state;
      final subscription = _childSubscriptions.remove(oldIndex)!;
      _childSubscriptions[newIndex] = subscription;
    }
    recalculateState();
  }

  @override
  void dispose() {
    for (final subscription in _childSubscriptions.values) {
      subscription.cancel();
    }
    _stateSubject.close();
  }

  @override
  void reset() {
    _childStates.clear();
    for (final subscription in _childSubscriptions.values) {
      subscription.cancel();
    }
    _childSubscriptions.clear();

    _stateSubject.add(ListState(config: config, items: []));
  }

  @override
  ListState createAggregatedState({
    required bool isDirty,
    required bool isTouched,
    required bool isValid,
  }) {
    final List<int> sortedKeys = _childStates.keys.map((k) => k).toList()
      ..sort();
    final List<IState> currentChildren =
        sortedKeys.map((key) => _childStates[key]!).toList();

    return state.copyWith(
      isDirty: isDirty,
      isTouched: isTouched,
      isValid: isValid,
      items: List.unmodifiable(currentChildren),
    );
  }
}
