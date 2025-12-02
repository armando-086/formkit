import 'package:formkit/src/node/contracts/i_node_visitor.dart';

abstract interface class IFormValidatorVisitor implements INodeVisitor {
  bool get formIsValid;
  Map<String, String> get errors;
}