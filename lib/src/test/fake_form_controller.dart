// import 'dart:async';
// import 'package:formkit/src/exceptions/contracts/i_error_translator.dart';
// import 'package:formkit/src/core/contracts/i_form_controller.dart';
// import 'package:formkit/src/mapping/contracts/i_form_mapper.dart';
// import 'package:formkit/src/state/contracts/i_form_state_store.dart';
// import 'package:formkit/src/config/contracts/i_form_schema.dart';
// import 'package:formkit/src/state/contracts/i_state.dart';
// import 'package:formkit/src/flutter/contracts/i_field_binder.dart';

// Helper: Stub básico para el IFormStateStore

// Helper: Stub básico para el IFormStateStore (Corrección de errores)
// Se usa Object como TState para cumplir con IFormStateStore<TState extends IState>

// class FakeFormController implements IFormController {
//   // . Instanciamos FakeFormStateStore. El contrato IFormController espera IFormStateStore.
//   final FakeFormStateStore _fakeStore = FakeFormStateStore();
  
//   // . Propiedad para simular el valor de retorno en pruebas (para validatedFlush y mapToEntity)
//   final Object? simulatedOutput; 

//   FakeFormController({this.simulatedOutput});

//   @override
//   IFormStateStore get stateStore => _fakeStore;

//   @override
//   Future<TOutputVO> validatedFlush<TOutputVO>({
//     required IFormMapper<TOutputVO> mapper,
//     required Map<String, IFieldBinder> fieldBinders,
//     required IErrorTranslator errorTranslator,
//   }) async {
//     // . Para facilitar pruebas, el Fake asume que la validación siempre pasa
//     // . y mapea el resultado si se le ha inyectado un valor.

//     // . Comprobación de que el TOutputVO coincida con el tipo inyectado (solo en desarrollo)
//     if (simulatedOutput != null && simulatedOutput is TOutputVO) {
//       return simulatedOutput as TOutputVO;
//     }

//     // . Si no se inyectó un valor simulado, se lanza una excepción o se retorna null (opción de Stub)
//     // . Para Stub:
//     throw Exception('FakeFormController no configurado para retornar un valor de tipo $TOutputVO. '
//         'Valor simulado: ${simulatedOutput.runtimeType}');
//   }

//   @override
//   void dispose() {
//     _fakeStore.dispose();
//   }


//   @override
//   TEntity mapToEntity<TEntity>() {
//     if (simulatedOutput is TEntity) {
//       return simulatedOutput as TEntity;
//     }
    
//     //. Lanzar excepción si el tipo no coincide para asegurar testability
//     throw Exception('FakeFormController no configurado para mapear a tipo $TEntity. '
//         'Configure simulatedOutput con el tipo correcto para la evaluación reactiva.');
//   }
// }

// // . STUB para FormSchema (Requerido por IState)
// class FakeFormSchema implements IFormSchema {
//   @override
//   String get name => 'FakeForm'; 
  
//   @override
//   Map<String, IFormSchema> get fields => const {};
// }  

// // . STUB para IState (Resuelve la restricción TState extends IState)
// class FakeState implements IState {
//   @override
//   final bool isValid = true;
//   @override
//   final bool isDirty = false;
//   @override
//   final bool isTouched = false;
//   @override
//   final String? errorMsg = null;
//   @override
//   final IFormSchema config = FakeFormSchema();
// }

// // . Helper: Stub básico para el IFormStateStore
// class FakeFormStateStore implements IFormStateStore<IState> {
  
//   @override
//   Stream<IState> get stream => Stream.empty();  

//   @override
//   IState get state => FakeState();  
  
//   @override
//   void reset() {
//     // No-op en el Fake
//   }

//   @override
//   void dispose() {
//     // No-op
//   }
// }