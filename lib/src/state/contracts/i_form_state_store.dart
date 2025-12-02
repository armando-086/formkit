import 'package:formkit/src/core/contracts/i_disposable.dart';
import 'package:formkit/src/state/contracts/i_state.dart';

abstract interface class IFormStateStore<TState extends IState> implements IDisposable {
  TState get state;
  Stream<TState> get stream;
  void reset();
}