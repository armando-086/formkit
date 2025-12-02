
abstract interface class ValueObject<P> {
  const ValueObject(this.value);
  /// Valor primitivo interno del VO.
  final P value;

}