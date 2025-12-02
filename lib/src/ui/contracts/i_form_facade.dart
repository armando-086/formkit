import 'package:flutter/material.dart';
import 'package:formkit/src/core/contracts/i_disposable.dart';

abstract interface class IFormFacade<TOutputVO> implements IDisposable {
  Future<void> validatedFlush();
  
  GlobalKey<FormState> get formKey;
  bool validate();
  void reset();
  Stream get stateStream;
}


