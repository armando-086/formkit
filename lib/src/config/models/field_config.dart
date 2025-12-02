import 'package:formkit/src/mapping/contracts/i_value_converter.dart';
import 'package:formkit/src/validation/contract/i_async_validator.dart';
import 'package:formkit/src/validation/contract/i_validator.dart';
import 'package:formkit/src/mapping/contracts/i_value_interceptor.dart';
import 'package:formkit/src/config/contracts/i_form_schema.dart';
import 'package:formkit/src/validation/services/required_validator.dart';
//. =============================================================
//. Configuración y API Fluida para campos individuales.
//. P: Tipo Primitivo (valor de entrada del widget, ej. String).
//. V: Tipo de Valor Final (valor procesado por el orchestrator, ej. int, ValueObject).
//. =============================================================
class FieldConfig<P, V> implements IFormSchema {
  final P? initialValue;
  @override
  final String name;
  final IValueConverter<P, V> valueConverter; 
  final List<IValueInterceptor<P, P>> interceptors;
  final List<IValidator<P>> validators;
  final List<IAsyncValidator<P>> asyncValidators;
  final bool Function(dynamic entity)? enableIf;
  final bool Function(dynamic entity)? isVisibleIf;

  FieldConfig({
    required this.name,
    this.initialValue,
    required this.valueConverter, 
    this.interceptors = const [],
    List<IValidator<P>>? validators,
    this.asyncValidators = const [],
    this.enableIf,
    this.isVisibleIf,
  }) : validators = _determineValidators(validators);

  static List<IValidator<P>> _determineValidators<P>(
      List<IValidator<P>>? userValidators) {
    if (userValidators != null) {
      return userValidators;
    }

    if (null is! P) {
      return [RequiredValidator<P>()];
    }

    return const [];  
  }

  @override
  Map<String, IFormSchema> get fields => {};
}