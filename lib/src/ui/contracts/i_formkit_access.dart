import 'package:flutter/widgets.dart';
import 'package:formkit/src/ui/contracts/i_field_controller.dart';

abstract interface class IFormKitAccess<TEntity> {
  GlobalKey<FormState> get formKey;

  IFieldController<P, V>? getController<P, V>(String fieldName);
  
  Map<String, IFieldController> get allControllers;
  
  Future<TEntity?> validatedFlush(); 
}