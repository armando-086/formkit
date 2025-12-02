import 'package:formkit/src/core/contracts/i_disposable.dart';
import 'package:formkit/src/state/state/field_state.dart';

abstract interface class IFieldController<P, V> implements IDisposable {
  V get value; 
  void setValue(V newValue);

  Stream<FieldState> get stateStream;
  FieldState get state; 
}