import 'package:flutter/material.dart';
import 'package:formkit/src/config/contracts/i_form_schema.dart';
import 'package:formkit/src/core/contracts/i_disposable.dart';
import 'package:formkit/src/ui/contracts/i_field_binder.dart';
import 'package:formkit/src/ui/contracts/i_field_controller.dart';

abstract interface class IControllerFactory implements IDisposable {
  GlobalKey<FormState> get formKey;

  /// Crea un controlador (e internamente su orquestador y binder) basado en el esquema.
  IFieldController createController(IFormSchema schema);

  /// Obtiene un controlador por su nombre/ID de campo.
  IFieldController? getController(String name);

  /// Mapa de FieldBinders para el Core Engine.
  Map<String, IFieldBinder> get binders;

  /// Llama a la validación completa y retorna el DTO/Entidad mapeada.
  /// 
  /// Delega la lógica de validación y mapeo al IFormController activo.
  Future<TOutputVO?> flush<TOutputVO>();

  /// Carga una entidad en el formulario. Delega al IFormController activo.
  void loadEntity<TEntity>(TEntity entity);

  /// Limpia y elimina todos los controladores y sus recursos asociados.
  void clearAllControllers();
}