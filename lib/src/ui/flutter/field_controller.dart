import 'dart:async';
import 'package:flutter/material.dart';
import 'package:formkit/src/core/contracts/i_disposable.dart';
import 'package:formkit/src/ui/contracts/i_text_field_controller.dart';
import 'package:formkit/src/node/orchestrator/field_orchestrator.dart';
import 'package:formkit/src/state/state/field_state.dart';


class FieldController<P, V> implements ITextFieldController<P, V>, IDisposable {
  final FieldOrchestrator<P, V> _orchestrator;
  
  TextEditingController? _textEditingController;
  StreamSubscription? _orchestratorSubscription;

  FieldController({
    required FieldOrchestrator<P, V> orchestrator,
    required P? initialRawValue,
  }) : _orchestrator = orchestrator {
    if (initialRawValue != null) {
      _orchestrator.setRawValue(initialRawValue);
    }
  }

  @override
  TextEditingController get textEditingController {
    if (_textEditingController == null) {
      _textEditingController = TextEditingController(
        text: _orchestrator.rawValue?.toString() ?? '',
      );

      _textEditingController!.addListener(_onTextChanged);
      _orchestratorSubscription = _orchestrator.rawValueStream.listen((newValue) {
        final newText = newValue?.toString() ?? '';
        if (_textEditingController!.text != newText) {
          _textEditingController!.value = _textEditingController!.value.copyWith(
            text: newText,
            selection: TextSelection.collapsed(offset: newText.length),
          );
        }
      });
    }
    return _textEditingController!;
  }

  void _onTextChanged() {
    _orchestrator.setRawValue(_textEditingController!.text as P);
  }

  @override
  V get value => _orchestrator.finalValue;

  @override
  void setValue(V newValue) {
    if (_textEditingController != null && newValue is String) {
      if (newValue != _textEditingController!.text) {
        _textEditingController!.text = newValue;
      }
    }  

    if (newValue is P) {
      _orchestrator.setRawValue(newValue);
    }
  }

  @override
  FieldState get state => _orchestrator.stateStore.state; 

  @override
  Stream<FieldState> get stateStream => _orchestrator.stateStream; 

  @override
  void dispose() {
    _orchestratorSubscription?.cancel();
    if (_textEditingController != null) {
      _textEditingController!.removeListener(_onTextChanged);
      _textEditingController!.dispose();
    }
  }
}