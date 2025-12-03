import 'package:flutter/material.dart';
import 'package:formkit/src/config/contracts/i_form_schema.dart';
import 'package:formkit/src/config/models/field_config.dart';
import 'package:formkit/src/core/contracts/i_form_controller.dart';
import 'package:formkit/src/core/contracts/i_formkit_locator.dart';
import 'package:formkit/src/core/contracts/i_service_locator.dart';
import 'package:formkit/src/core/engine/formkit_core_engine.dart';
import 'package:formkit/src/core/engine/node_walker.dart';
import 'package:formkit/src/core/locator/formkit_service_locator.dart';
import 'package:formkit/src/exceptions/contracts/i_error_translator.dart';
import 'package:formkit/src/exceptions/formkit_exeption.dart';
import 'package:formkit/src/ui/contracts/i_controller_factory.dart';
import 'package:formkit/src/ui/contracts/i_field_binder.dart';
import 'package:formkit/src/ui/contracts/i_formkit_access.dart';
import 'package:formkit/src/ui/contracts/i_text_field_controller.dart';
import 'package:formkit/src/ui/flutter/controller_factory_impl.dart';
import 'package:formkit/src/mapping/contracts/i_form_mapper.dart';
import 'package:formkit/src/node/contracts/i_form_node.dart';
import 'package:formkit/src/node/contracts/i_form_node_factory.dart';
import 'package:formkit/src/reactive/contract/i_reactive_engine.dart';
import 'package:formkit/src/reactive/engine/reactive_engine.dart';
import 'package:formkit/src/reactive/engine/noop_reactive_engine.dart';
import 'package:formkit/src/state/contracts/i_form_state_store.dart';
import 'package:formkit/src/validation/contract/i_async_validator_service.dart';
import 'package:formkit/src/validation/contract/i_form_validator_service.dart';
import 'package:formkit/src/validation/services/async_validator_service.dart';

class FormKitCore implements IFormKitLocator {
  static final FormKitCore _instance = FormKitCore._internal();
  final FormKitServiceLocator _serviceLocator = FormKitServiceLocator();
  FormKitCore._internal();
  static FormKitCore get instance => _instance;

  //. Mapa para almacenar los accesos tipados (generados por CodeGen), clave: Tipo de la Entidad de Salida (TEntity)
  final Map<Type, IFormKitAccess> _formKitAccesses = {}; 

  // . Campo para almacenar la factoría activa
  late final IControllerFactory _activeControllerFactory;

  @override
  IServiceLocator get locator => _serviceLocator;

  // . Getter interno de conveniencia con manejo de error
  static IControllerFactory get _factory {
    try {
      return _instance._activeControllerFactory;
    } on StateError catch (_) {
      throw FormKitException(
          'No active controller factory found. Ensure createForm has been called before accessing FormKit resources.');
    }
  }

  //. Registra una instancia de acceso tipado generada por el CodeGen.
  static void registerFormKitAccess<TEntity>(IFormKitAccess<TEntity> access) {
    _instance._formKitAccesses[TEntity] = access;
  }

  /// Recupera la instancia de acceso al formulario para un tipo de entidad dado.
  /// Útil para que los Blocs accedan a la FormKey y a los controladores tipados.
  static IFormKitAccess<TEntity> getFormKitAccess<TEntity>() {
    final access = _instance._formKitAccesses[TEntity];
    if (access == null) {
      throw FormKitException(
          'No FormKitAccess registered for type "$TEntity". Ensure the CodeGen ran successfully and the access class is registered.');
    }
    // El cast es seguro porque se almacena por su Type key.
    return access as IFormKitAccess<TEntity>;
  }

  static void
      registerService<TContract extends Object, TService extends TContract>(
          TService service) {
    _instance._serviceLocator.register<TContract, TService>(service);
  }

  static void registerDefaultServices() {
    final IServiceLocator locator = instance.locator;

    // 0. Registrar NodeWalker (servicio core sin estado)
    if (locator.tryResolve<NodeWalker>() == null) {
      registerService<NodeWalker, NodeWalker>(NodeWalker());
    }

    // 1. IAsyncValidatorService<dynamic>
    if (locator.tryResolve<IAsyncValidatorService<dynamic>>() == null) {
      registerService<IAsyncValidatorService<dynamic>,
          AsyncValidatorService<dynamic>>(AsyncValidatorService<dynamic>());
    }

    // 2. Registrar una implementación por defecto No-op de IReactiveEngine
    //    Esto permite inicializar la capa Flutter (FormKitFacade) que crea
    //    la factoría de controladores durante la inicialización de la app.
    if (locator.tryResolve<IReactiveEngine<dynamic>>() == null) {
      registerService<IReactiveEngine<dynamic>, IReactiveEngine<dynamic>>(
          NoopReactiveEngine<dynamic>());
    }
  }

  static void initializeCore() {
    registerDefaultServices();
  }

  static void registerControllerFactory(IControllerFactory factory) {
    // Almacenar la factoría activa para accesos rápidos y compatibilidad
    _instance._activeControllerFactory = factory;
    _instance._serviceLocator
        .register<IControllerFactory, IControllerFactory>(factory);
  }

  static IFormController<TEntity> createForm<TEntity>(
      {required IFormSchema<TEntity> schema}) {
    final IServiceLocator locator = instance.locator;

    // Asegurar que los servicios base estén registrados
    if (locator.tryResolve<NodeWalker>() == null) {
      registerDefaultServices();
    }

    final IFormStateStore store = locator.resolve<IFormStateStore>();
    final NodeWalker walker = locator.resolve<NodeWalker>();
    final IFormValidatorService validatorService =
        locator.resolve<IFormValidatorService>();
    final IFormNodeFactory nodeFactory = locator.resolve<IFormNodeFactory>();
    final IFormNode rootNode = nodeFactory.createRootNode(schema);
    final IFormMapper<TEntity> mapper = locator.resolve<IFormMapper<TEntity>>();
    final IErrorTranslator errorTranslator =
        locator.resolve<IErrorTranslator>();
    final IAsyncValidatorService asyncValidatorService =
        locator.resolve<IAsyncValidatorService<dynamic>>();

    // Crear el engine del formulario PRIMERO (sin ReactiveEngine todavía)
    final FormKitCoreEngine<TEntity> engine = FormKitCoreEngine<TEntity>(
      rootNode: rootNode,
      stateStore: store,
      walker: walker,
      validatorService: validatorService,
      mapper: mapper,
      errorTranslator: errorTranslator,
      fieldBinders: <String, IFieldBinder>{},
    );

    // AHORA crear ReactiveEngine con el controller y walker
    final IReactiveEngine<TEntity> reactiveEngine =
        ReactiveEngine<TEntity>(walker, engine);

    // Registrar el ReactiveEngine en el locator para el formulario actual
    locator.register<IReactiveEngine<TEntity>, IReactiveEngine<TEntity>>(
        reactiveEngine);

    // Crear la factoría de controladores CON ReactiveEngine
    final ControllerFactoryImpl controllerFactory = ControllerFactoryImpl(
      reactiveEngine: reactiveEngine,
      asyncValidatorService: asyncValidatorService,
    );

    // . Almacenar la factoría activa
    _instance._activeControllerFactory = controllerFactory;

    // Crear los controladores del formulario
    _createControllers(schema, controllerFactory);

    // Obtener los binders y asignarlos al engine
    final Map<String, IFieldBinder> fieldBinders = controllerFactory.binders;
    engine.fieldBinders = fieldBinders;

    return engine;
  }

  // . Getter estático para la factoría de controladores activa.
  static IControllerFactory get activeControllerFactory =>
      _instance._activeControllerFactory;

  static GlobalKey<FormState> getFormKey({required String key}) {
    return _factory.formKey;
  }

  static ITextFieldController<String, TValue>? getController<TValue>(
      {required String fieldId}) {
    final controller = _factory.getController(fieldId);

    if (controller == null) {
      return null;
    }

    if (controller is! ITextFieldController<String, TValue>) {
      throw FormKitException(
          'Controller "$fieldId" found but type mismatch. Expected ITextFieldController<String, $TValue> but got ${controller.runtimeType}');
    }
    return controller;
  }

  static Future<TOutputVO?> flush<TOutputVO>() async {
    // . Implementación real de FormKit para limpieza de formulario
    return _factory.validatedFlush<TOutputVO>();
  }

  // . Método estático para cargar la Entidad (soluciona error 'loadEntity').
  static void loadEntity<TEntity>(TEntity entity) {
    // . Se delega a la factoría de controladores activa la responsabilidad de cargar la entidad
    _factory.loadEntity<TEntity>(entity);
  }

  // . Método estático para liberar los recursos (soluciona error 'disposeForm').
  static void disposeForm<TEntity>() {
    // . Se delega a la factoría de controladores activa la responsabilidad de liberar recursos.
    _factory.clearAllControllers();
  }

  // . Método auxiliar estático para iterar recursivamente el esquema y crear controladores.
  static void _createControllers(
      IFormSchema schema, IControllerFactory factory) {
    schema.fields.forEach((name, childSchema) {
      if (childSchema is FieldConfig) {
        factory.createController(childSchema);
      } else {
        _createControllers(childSchema, factory);
      }
    });
  }
}