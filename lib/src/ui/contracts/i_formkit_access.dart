import 'package:flutter/widgets.dart';
import 'package:formkit/src/ui/contracts/i_field_controller.dart';

// Este es el contrato que FormKitGenerator implementará para cada clase DTO/Entity.
// El Bloc recibirá una instancia de este contrato via DI para exponerlo a la Vista.
abstract interface class IFormKitAccess<TEntity> {
  // La FormKey global para el formulario asociado a esta entidad.
  GlobalKey<FormState> get formKey;

  // Método genérico para obtener un controlador de campo.
  // Se utiliza IFieldController<P, V> para asegurar la compatibilidad con el Core Engine.
  IFieldController<P, V>? getController<P, V>(String fieldName);

  // Propiedad para acceder a todos los controladores, útil para la limpieza o inicialización.
  Map<String, IFieldController> get allControllers;
}
