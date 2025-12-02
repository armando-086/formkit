import 'package:formkit/src/config/contracts/i_form_schema.dart';
import 'package:formkit/src/core/contracts/i_disposable.dart';
import 'package:formkit/src/node/contracts/i_node_visitor.dart';

abstract interface class IFormNode implements IDisposable {
  String get name;
  IFormSchema get config;

  void setParent(IFormNode? parent);
  void accept(INodeVisitor visitor);
}
