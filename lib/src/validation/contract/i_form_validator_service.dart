import 'package:formkit/src/core/contracts/i_disposable.dart';
import 'package:formkit/src/node/contracts/i_form_node.dart';

abstract interface class IFormValidatorService implements IDisposable {
  Map<String, String> getErrors(IFormNode rootNode);
  bool validate(IFormNode rootNode);

  Future<void> runAllAsyncValidation(IFormNode rootNode);
}