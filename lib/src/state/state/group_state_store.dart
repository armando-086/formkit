import 'dart:async';
import 'package:formkit/src/core/contracts/i_disposable.dart';
import 'package:formkit/src/state/contracts/i_form_state_store.dart';
import 'package:formkit/src/config/contracts/i_form_schema.dart';
import 'package:formkit/src/state/state/group_state.dart';
import 'package:formkit/src/state/contracts/i_state.dart';
import 'package:formkit/src/state/state/state_aggregator_mixin.dart';
import 'package:rxdart/subjects.dart';

class GroupStateStore
    with
        StateAggregatorMixin<
            GroupState>  
    implements
        IFormStateStore<GroupState>,
        IDisposable {
  final Map<String, IState> _childStates = {};
  @override
  Map<Object, IState> get childStates => _childStates
      .cast<Object, IState>();

  final BehaviorSubject<GroupState> _stateSubject;
  @override
  BehaviorSubject<GroupState> get stateSubject =>
      _stateSubject;  

  final Map<String, StreamSubscription> _childSubscriptions = {};
  final IFormSchema config;

  GroupStateStore({
    required this.config,
    GroupState? initialState,
  }) : _stateSubject = BehaviorSubject<GroupState>.seeded(
          initialState ?? GroupState(config: config),
        );

  @override
  GroupState get state => _stateSubject.value;
  Stream<GroupState> get stateStream => _stateSubject.stream;

  @override
  Stream<GroupState> get stream => _stateSubject.stream;

  void registerChildStateStream(String name, Stream<IState> childStateStream) {
    if (_childSubscriptions.containsKey(name)) {
      _childSubscriptions[name]?.cancel();
    }

    _childSubscriptions[name] = childStateStream.listen((state) {
      _childStates[name] = state;
      recalculateState(); 
    });
  }

  void unregisterChildStateStream(String name) {
    _childSubscriptions[name]?.cancel();
    _childSubscriptions.remove(name);
    _childStates.remove(name);
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
    _stateSubject.add(GroupState(config: config, isValid: true));
  }

  @override
  GroupState createAggregatedState({
    required bool isDirty,
    required bool isTouched,
    required bool isValid,
  }) {
    return state.copyWith(
      isDirty: isDirty,
      isTouched: isTouched,
      isValid: isValid,
    );
  }
}