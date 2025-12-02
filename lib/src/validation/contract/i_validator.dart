abstract interface class IValidator<T> {
  String? validate(T value, {String? fieldName});
}