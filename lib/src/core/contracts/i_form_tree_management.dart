import 'package:formkit/src/node/contracts/i_form_node.dart';
import 'package:formkit/src/node/contracts/i_node_visitor.dart';

abstract interface class IFormTreeManagement {
  void reset(IFormNode rootNode);
  void dispose(IFormNode rootNode);
  void walk(IFormNode rootNode, INodeVisitor visitor);
}