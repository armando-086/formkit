abstract interface class IAsyncValidator<P> {
  Future<String?> validate(P value);
}