import 'package:formkit/src/mapping/contracts/i_value_converter.dart';

class ValueObjectConverter<P, V> implements IValueConverter<P, V> {
  final V Function(P primitive) _fromPrimitive;

  const ValueObjectConverter(this._fromPrimitive);

  @override
  V convert(P rawValue) => _fromPrimitive(rawValue);
}