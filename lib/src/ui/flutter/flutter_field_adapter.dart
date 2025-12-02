import 'dart:async';
import 'package:flutter/material.dart';
import 'package:formkit/src/node/orchestrator/field_orchestrator.dart';
import 'package:formkit/src/state/contracts/i_state.dart';
import 'package:formkit/src/ui/contracts/i_field_binder.dart';

//. =============================================================
//. Adaptador que enlaza FieldOrchestrator con los Widgets de Flutter.
//. Implementa IFieldBinder<P>.
//. P: Tipo Primitivo de entrada (Input).
//. V: Tipo de Valor Final procesado (Output).
//. =============================================================
class FlutterFieldAdapter<P, V> implements IFieldBinder {
  @override
  final String name;  
  final FieldOrchestrator<P, V> _orchestrator;
  final ValueNotifier<P?> _valueNotifier; 
  late final StreamSubscription<P?> _valueSubscription; 

  FlutterFieldAdapter({
    required this.name,  
    required FieldOrchestrator<P, V> orchestrator,
  })  : _orchestrator = orchestrator,
        _valueNotifier = ValueNotifier<P?>(orchestrator.rawValue) { 
    
    _valueSubscription = _orchestrator.rawValueStream.listen((newValue) { 
      if (_valueNotifier.value != newValue) {
        _valueNotifier.value = newValue;
      }
    });
  }

  ValueNotifier<P?> get valueNotifier => _valueNotifier; 

  Stream<IState> get stateStream => _orchestrator.stateStream as Stream<IState>;

  void setValue(P newValue) {
    _orchestrator.setRawValue(newValue);
  }

  void resetField() {
    _orchestrator.reset(); 
  }
  
  @override
  void setErrorMsg(String? errorMsg) {
    _orchestrator.stateStore.setValidation(
      isValid: errorMsg == null,
      errorMsg: errorMsg,
    );
  }
  
  @override
  dynamic getCurrentRawValue() {
    return _orchestrator.rawValue; 
  }

  @override  
  void dispose() {
    _valueSubscription.cancel();
    _valueNotifier.dispose();
  }
}