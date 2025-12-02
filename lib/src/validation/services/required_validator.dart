import 'package:formkit/src/validation/contract/i_validator.dart';

class RequiredValidator<P> implements IValidator<P> {
  const RequiredValidator();

  @override
  String? validate(P value, {String? fieldName}) {
    if (value == null) {
      return 'required';
    }

    if (value is String) {
      if (value.trim().isEmpty) {
        return 'required';
      }
    } else if (value is int) {
      if (value == 0) {
        return 'required';
      }
    } else if (value is double) {
      if (value == 0.0) {
        return 'required';
      }
    }else if (value is Iterable) {
      if (value.isEmpty) {
        return 'required';
      }
    } else if (value is Map) {
      if (value.isEmpty) {
        return 'required';
      }
    }
    
    return null;
  }
}
