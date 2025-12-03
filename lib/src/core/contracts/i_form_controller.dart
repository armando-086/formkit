import 'package:formkit/src/core/contracts/i_disposable.dart';
import 'package:formkit/src/state/contracts/i_form_state_store.dart';

abstract interface class IFormController<TEntity> implements IDisposable {
  IFormStateStore get stateStore;

  void loadEntity(TEntity entity);
  TEntity toEntity();

  Future<void> validatedFlush<TOutputVO>();
  
  // Future<TOutputVO> validatedFlush<TOutputVO>({
  //   required IFormMapper<TOutputVO> mapper,
  //   required Map<String, IFieldBinder> fieldBinders,
  //   required IErrorTranslator errorTranslator,
  // });
}

