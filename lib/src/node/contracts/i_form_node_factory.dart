import 'package:formkit/src/config/contracts/i_form_schema.dart';
import 'package:formkit/src/node/contracts/i_form_node.dart';

abstract interface class IFormNodeFactory {
  IFormNode createRootNode(IFormSchema schema);
}