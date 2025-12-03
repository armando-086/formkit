
abstract interface class ValueObject<P> {
  const ValueObject(this.value);
  final P value;
}