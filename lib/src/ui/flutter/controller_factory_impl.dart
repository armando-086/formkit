import 'package:flutter/material.dart';
import 'package:formkit/src/config/contracts/i_form_schema.dart';
import 'package:formkit/src/config/models/field_config.dart';
import 'package:formkit/src/core/contracts/i_form_controller.dart';
import 'package:formkit/src/core/formkit_core.dart';
import 'package:formkit/src/exceptions/fomkit_validation_exeption.dart';
import 'package:formkit/src/ui/contracts/i_controller_factory.dart';
import 'package:formkit/src/ui/contracts/i_field_binder.dart';
import 'package:formkit/src/ui/contracts/i_field_controller.dart';
import 'package:formkit/src/ui/flutter/field_binder.dart';
import 'package:formkit/src/ui/flutter/field_controller.dart';
import 'package:formkit/src/node/orchestrator/field_orchestrator.dart';
import 'package:formkit/src/reactive/contract/i_reactive_engine.dart';
import 'package:formkit/src/state/state/field_state_store.dart';
import 'package:formkit/src/validation/contract/i_async_validator_service.dart';

class ControllerFactoryImpl implements IControllerFactory {
  final IReactiveEngine _reactiveEngine;
  final IAsyncValidatorService _asyncValidatorService;

  ControllerFactoryImpl({
    required IReactiveEngine reactiveEngine,
    required IAsyncValidatorService asyncValidatorService,
  })  : _reactiveEngine = reactiveEngine,
        _asyncValidatorService = asyncValidatorService;

  // 1. Contener y exponer la GlobalKey<FormState>
  @override
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // 3. Mantener y exponer el mapa de IFieldBinder
  final Map<String, IFieldBinder> _binders = {};
  @override
  Map<String, IFieldBinder> get binders => _binders;

  final Map<String, IFieldController> _controllers = {};

  @override
  IFieldController createController(IFormSchema schema) {
    // 1. Validación de tipo y cast: Se debe castear a FieldConfig para acceder a las propiedades
    if (schema is! FieldConfig) {
      throw Exception('ControllerFactory solo soporta FieldConfig schemas.');
    }

    // 2. Usar un método auxiliar genérico para resolver los tipos P (Raw Value) y V (Final Value).
    return _createControllerInternal(schema);
  }

  IFieldController _createControllerInternal<P, V>(FieldConfig<P, V> config) {
    // 1. Crear FieldStateStore usando el constructor real que requiere config, initialRawValue y converter.
    final stateStore = FieldStateStore<P, V>(
      config: config,
      initialRawValue: config.initialValue,
      converter: config.valueConverter,
    );

    // 2. Crear el Orquestador: Se pasan TODOS los 9 parámetros requeridos por FieldOrchestrator.
    final orchestrator = FieldOrchestrator<P, V>(
      fieldName: config.name,
      validators: config.validators,
      asyncValidators: config.asyncValidators,
      valueConverter: config.valueConverter,
      interceptors: config.interceptors,
      stateStore: stateStore,
      config: config,
      asyncValidatorService:
          _asyncValidatorService as IAsyncValidatorService<P>,
      reactiveEngine: _reactiveEngine,
      initialRawValue: config.initialValue,
    );

    // 3. Crear el Binder (Interfaz para el Core Engine)
    final binder = FieldBinder<P, V>(
      name: config.name,
      orchestrator: orchestrator,
    );
    _binders[config.name] = binder;

    // 4. Crear el Controller (Interfaz para la Vista/Flutter)
    final controller = FieldController<P, V>(
      orchestrator: orchestrator,
      initialRawValue: config.initialValue,
    );
    _controllers[config.name] = controller;

    return controller;
  }

  @override
  IFieldController? getController(String name) {
    return _controllers[name];
  }

  // . =================================================================
  // . IMPLEMENTACIONES REQUERIDAS POR IControllerFactory
  // . =================================================================

  // . Implementación del método clearAllControllers
  @override
  void clearAllControllers() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
    _binders.clear();
  }

  // . El método dispose ahora delega la limpieza al nuevo método.
  @override
  void dispose() {
    clearAllControllers();
  }

  // . Carga una Entidad. Delega al IFormController activo (asumiendo registro en Locator).
  @override
  void loadEntity<TEntity>(TEntity entity) {
    // . Resuelve el IFormController activo para esta entidad desde el Service Locator y ejecuta la carga.
    final formController =
        FormKitCore.instance.locator.resolve<IFormController<TEntity>>();
    formController.loadEntity(entity);
  }

  // . Obtiene el DTO mapeado (flush). Delega al IFormController activo.
  @override
  Future<TOutputVO?> validatedFlush<TOutputVO>() async {
    // . Resuelve el IFormController activo para esta entidad/DTO desde el Service Locator.
    // . Se asume que TOutputVO es el tipo de TEntity registrado para este formulario.
    final formController =
        FormKitCore.instance.locator.resolve<IFormController<TOutputVO>>();

    try {
      // 1. Ejecutar validación completa (incluyendo asíncronas).
      // Si la validación falla (UI o de Dominio), FormKitCoreEngine lanza FormKitValidationException.
      await formController.validatedFlush<TOutputVO>();

      // 2. Si la validación pasa, mapear y retornar la entidad/DTO.
      return formController.toEntity() as TOutputVO?;
    } on FormKitValidationException {
      // 3. Capturar la excepción de validación.
      // Se retorna null, cumpliendo con el objetivo de evitar el try/catch en el Bloc.
      return null;
    }
  }
}
