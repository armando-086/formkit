import 'package:formkit/src/node/contracts/i_form_node.dart';

abstract interface class IFormContainerNode implements IFormNode {
  List<IFormNode> get children;
}

