import 'package:formkit/src/ui/contracts/i_field_controller.dart';
import 'package:formkit/src/state/state/field_state.dart';
import 'package:rxdart/rxdart.dart';
// Se asumen los imports de los contratos requeridos.
// import 'package:formkit/src/contracts/IFieldController.dart';
// import 'package:formkit/src/core/state/field_state.dart'; // Se asume este import

class FakeFieldController<P, V> implements IFieldController<P, V> {
  //. Use BehaviorSubject para simular el estado observable
  final _stateSubject = BehaviorSubject<FieldState>();
  
  V _value;
  FieldState _state;

  FakeFieldController({required V initialValue, required FieldState initialState})
      : _value = initialValue,
        _state = initialState {
    _stateSubject.add(_state);
  }

  @override
  V get value => _value;

  @override
  void setValue(V newValue) {
    _value = newValue;
  }

  @override
  Stream<FieldState> get stateStream => _stateSubject.stream;

  @override
  FieldState get state => _state;

  @override
  void dispose() {
    _stateSubject.close();
  }
}