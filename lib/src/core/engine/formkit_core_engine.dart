import 'package:formkit/src/config/models/form_schema_impl.dart';
import 'package:formkit/src/mapping/contracts/i_data_accessor.dart';
import 'package:formkit/src/exceptions/contracts/i_error_translator.dart';
import 'package:formkit/src/core/contracts/i_form_controller.dart';
import 'package:formkit/src/mapping/contracts/i_form_mapper.dart';
import 'package:formkit/src/mapping/engine/default_map_accesor.dart';
import 'package:formkit/src/mapping/visitor/form_mapper_visitor.dart';
import 'package:formkit/src/state/contracts/i_form_state_store.dart';
import 'package:formkit/src/validation/contract/i_form_validator_service.dart';
import 'package:formkit/src/exceptions/fomkit_validation_exeption.dart';
import 'package:formkit/src/exceptions/value_failure_exception.dart';
import 'package:formkit/src/node/node/field_node.dart';
import 'package:formkit/src/node/contracts/i_form_node.dart';
import 'package:formkit/src/core/engine/node_walker.dart';
import 'package:formkit/src/ui/contracts/i_field_binder.dart';


class FormKitCoreEngine<TEntity> implements IFormController<TEntity> {
  final IFormNode _rootNode;
  @override
  final IFormStateStore stateStore;
  final NodeWalker _walker;
  final IFormValidatorService _validatorService;
  final IErrorTranslator _errorTranslator;
  late final Map<String, IFieldBinder> _fieldBinders;
  final IFormMapper<TEntity> _mapper;

  FormKitCoreEngine({
    required IFormNode rootNode,
    required this.stateStore,
    required NodeWalker walker,
    required IFormValidatorService validatorService,
    required IErrorTranslator errorTranslator,
    required Map<String, IFieldBinder> fieldBinders,
    required IFormMapper<TEntity> mapper,
  })  : _rootNode = rootNode,
        _walker = walker,
        _validatorService = validatorService,
        _errorTranslator = errorTranslator,
        _mapper = mapper {
    _fieldBinders = fieldBinders;
  }

  // . Setter para actualizar fieldBinders después de la creación
  set fieldBinders(Map<String, IFieldBinder> binders) {
    _fieldBinders.clear();
    _fieldBinders.addAll(binders);
  }

  // . =======================================================================
  // . Implementación del Mapeado Automático (loadEntity y toEntity)
  // . =======================================================================

  @override
  void loadEntity(TEntity entity) {
    final schema = _rootNode.config as FormSchemaImpl<TEntity>;
    if (schema.entityLoader == null) {
      throw StateError(
          'FormKitCoreEngine: No se puede llamar a loadEntity() sin un entityLoader.');
    }

    final Map<String, dynamic> data = schema.entityLoader!(entity);

    _walker.hydrate<Map<String, dynamic>>(_rootNode, data, DefaultMapAccessor());
  }

  @override
  TEntity toEntity() {
    final schema = _rootNode.config as FormSchemaImpl<TEntity>;
    if (schema.entityFactory == null) {
      throw StateError(
          'FormKitCoreEngine: No se puede llamar a toEntity() sin un entityFactory.');
    }

    final FormMapperVisitor visitor = FormMapperVisitor();
    _walker.walk(_rootNode, visitor);

    final Map<String, dynamic> formModel =
        visitor.getMapResult<Map<String, dynamic>>();

    return schema.entityFactory!(formModel);
  }

  // . =======================================================================
  // . Implementación de IFormController (Método validatedFlush)
  // . =======================================================================
  //. Implementa la lógica unificada de validación (asíncrona y síncrona) y mapeo (validación de dominio).
  @override
  Future<void> validatedFlush<TOutputVO>() async {
    // 1. Ejecutar validación asíncrona en todos los campos y esperar a que terminen.
    await _validatorService.runAllAsyncValidation(_rootNode);

    // 2. Ejecutar validación síncrona/UI (incluyendo resultados de la validación asíncrona recién terminada).
    final bool uiIsValid = validate();
    if (!uiIsValid) {
      // 3. Si falla la validación UI (síncrona o asíncrona), se lanza la excepción.
      throw FormKitValidationException(
        message: 'UI Validation Failed. Please check the fields.',
        errors: _validatorService.getErrors(_rootNode),
      );
    }

    try {
      // 4. Ejecutar el mapeo de dominio. El resultado se ignora (Future<void>),
      _mapper.map(_rootNode);
    } on ValueFailureException catch (e) {
      // 5. Si falla la validación de dominio (ValueFailureException),
      final String uiErrorMsg = _errorTranslator.translate(e.valueFailure);
      final IFieldBinder? binder = _fieldBinders[e.fieldName];
      if (binder != null) {
        binder.setErrorMsg(uiErrorMsg);
      } else {
        final IFormNode? fieldNode =
            _walker.findNodeByName(_rootNode, e.fieldName);
        if (fieldNode is FieldNode) {
          fieldNode.fieldOrchestrator.stateStore.setValidation(
            isValid: false,
            errorMsg: uiErrorMsg,
          );
        }
      }

      // 6. Finalmente, se lanza una excepción de validación para detener el flujo.
      throw FormKitValidationException(
        message: 'Domain Validation Failed during mapping.',
        errors: {e.fieldName: uiErrorMsg},
      );
    }
  }

  bool validate() {
    try {
      _validatorService.validate(_rootNode);
      return true;
    } on FormKitValidationException {
      return false;
    }
  }

  void reset() {
    _walker.reset(_rootNode);
  }

  @override
  void dispose() {
    stateStore.dispose();
    _walker.dispose(_rootNode);
    _validatorService.dispose();
  }

  void hydrate(TEntity entity, IDataAccessor<TEntity> accessor) {
    _walker.hydrate(_rootNode, entity, accessor);
  }
}