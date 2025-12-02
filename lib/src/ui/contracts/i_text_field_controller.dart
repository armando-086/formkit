import 'package:flutter/material.dart';
import 'package:formkit/src/ui/contracts/i_field_controller.dart';

abstract interface class ITextFieldController<P, V> implements IFieldController<P, V> {
  TextEditingController get textEditingController;
}