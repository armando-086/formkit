import 'package:formkit/src/core/contracts/i_disposable.dart';
import 'package:formkit/src/state/contracts/i_form_state_store.dart';

abstract interface class IFormController<TEntity> implements IDisposable {
  IFormStateStore get stateStore;
  
  /// Carga la entidad [TEntity] en todos los campos del formulario.
  void loadEntity(TEntity entity);
  
  /// Mapea el estado actual del formulario a la entidad de salida [TEntity].
  TEntity toEntity();

  /// Desencadena la validación completa del formulario, incluyendo validadores asíncronos.
  ///
  /// El tipo [TOutputVO] es típicamente el mismo que [TEntity] para el mapeo final.
  Future<void> validatedFlush<TOutputVO>();
}