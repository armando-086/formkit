import 'package:formkit/src/mapping/contracts/i_value_converter.dart';

class DefaultValueConverter<V> implements IValueConverter<V, V> {
  const DefaultValueConverter();

  @override
  V convert(V rawValue) => rawValue;
}