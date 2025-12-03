//. =========================================================================
//.         EXPORTACIÓN PÚBLICA DE FORMKIT V10 - FACHADA MÍNIMA
//. =========================================================================

//. -------------------------------------------------------------------------
//. 0. Inicialización y Fachada Principal
//. -------------------------------------------------------------------------
export 'src/ui/contracts/formkit_facade.dart' show FormKitFacade;
export 'src/core/formkit_core.dart' show FormKitCore;
export 'src/core/contracts/i_disposable.dart';

//. -------------------------------------------------------------------------
//. 1. Contratos de Alto Nivel y Estado
//. -------------------------------------------------------------------------
export 'src/core/contracts/i_form_controller.dart';
export 'src/ui/contracts/i_form_facade.dart';
export 'src/state/contracts/i_form_state_store.dart';
export 'src/state/contracts/i_state.dart';

//. -------------------------------------------------------------------------
//. 2. Estructura y Configuración del Formulario
//. -------------------------------------------------------------------------
export 'src/config/contracts/i_form_schema.dart';
export 'src/config/models/field_config.dart';
export 'src/config/models/group_config.dart';
export 'src/config/models/list_config.dart';
export 'src/config/models/form_schema_impl.dart';
export 'src/ui/contracts/i_text_field_controller.dart';
export 'src/ui/contracts/i_controller_factory.dart';

//. -------------------------------------------------------------------------
//. 3. Contratos de Extensibilidad y Utilidades
//. -------------------------------------------------------------------------
export 'src/mapping/contracts/i_form_mapper.dart';
export 'src/mapping/contracts/i_data_accessor.dart';
export 'src/ui/contracts/i_field_binder.dart';
export 'src/exceptions/contracts/i_error_translator.dart';

export 'src/validation/contract/i_validator.dart';
export 'src/mapping/contracts/value_object.dart' show ValueObject;
export 'src/validation/contract/i_async_validator.dart';
export 'src/mapping/contracts/i_value_interceptor.dart';
export 'src/mapping/contracts/i_value_converter.dart';
export 'src/mapping/services/value_object_converter.dart';

export 'src/validation/services/required_validator.dart';
export 'src/mapping/services/value_converter.dart';

export 'src/core/contracts/i_service_locator.dart';
export 'src/core/contracts/i_formkit_locator.dart';
export 'src/reactive/contract/i_reactive_engine.dart';

//. -------------------------------------------------------------------------
//. 3b. Code Generation: Anotaciones y Builder
//. -------------------------------------------------------------------------
export 'src/annotation/formkit_target.dart' show FormKitTarget;

//. -------------------------------------------------------------------------
//. 4. Exceptions
//. -------------------------------------------------------------------------
export 'src/exceptions/formkit_exeption.dart' show FormKitException;
export 'src/exceptions/fomkit_validation_exeption.dart';

