import 'package:formkit/src/mapping/contracts/i_value_converter.dart';

class ValueConverter<P, V> implements IValueConverter<P, V> { 
  final P Function(V value) _toPrimitive;
  final V Function(P primitive) _fromPrimitive;

  const ValueConverter._({
    required P Function(V value) toPrimitive,
    required V Function(P primitive) fromPrimitive,
  })  : _toPrimitive = toPrimitive,
        _fromPrimitive = fromPrimitive;

  factory ValueConverter.from({
    required P Function(V value) toPrimitive,
    required V Function(P primitive) fromPrimitive,
  }) {
    return ValueConverter<P, V>._(
      toPrimitive: toPrimitive,
      fromPrimitive: fromPrimitive,
    );
  }

  factory ValueConverter.fromFunction(
    V Function(P primitive) fromPrimitive,
  ) {
    return ValueConverter<P, V>._( 
      toPrimitive: (v) => throw UnimplementedError('toPrimitive no implementado, solo fromPrimitive es requerido.'),
      fromPrimitive: fromPrimitive,
    );
  }

  @override 
  V convert(P rawValue) => _fromPrimitive(rawValue);

  P toPrimitive(V finalValue) => _toPrimitive(finalValue);
}