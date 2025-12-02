import 'package:formkit/src/exceptions/contracts/i_error_translator.dart';

class FakeErrorTranslator implements IErrorTranslator {
  final String translationStub;
  FakeErrorTranslator({this.translationStub = 'Error traducido'});
  @override
  String translate(Object valueFailure) {
    //. El Fake traduce el fallo a un mensaje genérico o al stub predefinido,
    return '$translationStub para ${valueFailure.runtimeType}';
  }
}