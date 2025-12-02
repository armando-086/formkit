import 'package:formkit/src/exceptions/formkit_exeption.dart';
import 'package:formkit/src/mapping/contracts/i_value_converter.dart';

class ValueObjectConverter<P, V> implements IValueConverter<P, V> { 
  const ValueObjectConverter();

  @override 
  V convert(P rawValue) {
    try {
      final dynamic result = (V as dynamic).fromValue(rawValue);
      return result as V;
    } on NoSuchMethodError {
      throw FormKitException(
          'El Value Object $V debe tener un constructor estático `fromValue($P primitive)`.'
      );
    } catch (e) {
      rethrow;
    }
  }
}