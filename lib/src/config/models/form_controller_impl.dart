import 'package:formkit/src/core/contracts/i_disposable.dart';
import 'package:formkit/src/exceptions/contracts/i_error_translator.dart';
import 'package:formkit/src/ui/contracts/i_field_binder.dart';
import 'package:formkit/src/mapping/contracts/i_form_mapper.dart';
import 'package:formkit/src/state/contracts/i_form_state_store.dart';

abstract interface class IFormController<TEntity> implements IDisposable {
  IFormStateStore get stateStore;

  void loadEntity(TEntity entity);
  TEntity toEntity();
  
  Future<TOutputVO> validatedFlush<TOutputVO>({
    required IFormMapper<TOutputVO> mapper,
    required Map<String, IFieldBinder> fieldBinders,
    required IErrorTranslator errorTranslator,
  });
}