import 'package:flutter/material.dart';
import 'package:formkit/src/core/contracts/i_service_locator.dart';
import 'package:formkit/src/core/formkit_core.dart';
import 'package:formkit/src/ui/contracts/i_controller_factory.dart';
import 'package:formkit/src/ui/contracts/i_formkit_access.dart';
import 'package:formkit/src/ui/contracts/i_text_field_controller.dart';
import 'package:formkit/src/ui/flutter/controller_factory_impl.dart';
import 'package:formkit/src/reactive/contract/i_reactive_engine.dart';
import 'package:formkit/src/validation/contract/i_async_validator_service.dart';


abstract final class FormKitFacade {

  static IFormKitAccess<TEntity> getAccess<TEntity>() =>
      FormKitCore.getFormKitAccess<TEntity>();

  static void initializeFlutter() {
    final IServiceLocator locator = FormKitCore.instance.locator;

    // 1. Resolver las dependencias necesarias para ControllerFactoryImpl
    final IReactiveEngine<dynamic> reactiveEngine =
        locator.resolve<IReactiveEngine<dynamic>>();
    final IAsyncValidatorService<dynamic> asyncValidatorService =
        locator.resolve<IAsyncValidatorService<dynamic>>();

    // 2. Instanciar la implementación concreta.
    final IControllerFactory factory = ControllerFactoryImpl(
      reactiveEngine: reactiveEngine,
      asyncValidatorService: asyncValidatorService,
    );

    // 3. Registrar la factoría en el FormKit Core.
    FormKitCore.registerControllerFactory(factory);
  }

  static GlobalKey<FormState> get formKey =>
      FormKitCore.getFormKey(key: 'IgnoredKey');

  static ITextFieldController<String, TValue>? getController<TValue>(
          {required String fieldId}) =>
      FormKitCore.getController(fieldId: fieldId);

  static Future<TOutputVO?> validatedFlush<TOutputVO>() =>
      FormKitCore.flush<TOutputVO>();

  // . Método estático para cargar la Entidad (soluciona error 'loadEntity').
  static void loadEntity<TEntity>(TEntity entity) =>
      FormKitCore.loadEntity<TEntity>(entity);

  // . Método estático para limpiar y liberar el formulario (soluciona error 'clearForm').
  static void clearForm<TEntity>() => FormKitCore.disposeForm<TEntity>();
}
