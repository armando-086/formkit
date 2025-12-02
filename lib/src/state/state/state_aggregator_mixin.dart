import 'package:formkit/src/state/contracts/i_state.dart';
import 'package:rxdart/subjects.dart';

mixin StateAggregatorMixin<TState extends IState> {
  Map<Object, IState> get childStates;
  BehaviorSubject<TState> get stateSubject;
  TState createAggregatedState({
    required bool isDirty,
    required bool isTouched,
    required bool isValid,
  });

  void recalculateState() {
    if (childStates.isEmpty) {
      stateSubject.add(createAggregatedState(
        isDirty: false,
        isTouched: false,
        isValid: true,
      ));
      return;
    }

    final Iterable<IState> childrenStates = childStates.values;
    final bool anyDirty = childrenStates.any((state) => state.isDirty);
    final bool anyTouched = childrenStates.any((state) => state.isTouched);
    final bool allValid = childrenStates.every((state) => state.isValid);

    final newState = createAggregatedState(
      isDirty: anyDirty,
      isTouched: anyTouched,
      isValid: allValid,
    );

    stateSubject.add(newState);
  }
}
