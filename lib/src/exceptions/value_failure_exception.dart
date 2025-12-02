import 'package:formkit/src/exceptions/formkit_exeption.dart';

class ValueFailureException extends FormKitException {
  final String fieldName;
  final Object valueFailure; 

  ValueFailureException({
    required this.fieldName,
    required this.valueFailure,
    String? message,
  }) : super(message ?? 'Domain validation failed for field $fieldName.');

  @override
  String toString() => 'ValueFailureException: ${super.message}. Field: $fieldName, Failure: $valueFailure';
}