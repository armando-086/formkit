import 'package:formkit/src/node/contracts/i_form_node.dart';
abstract class IFormMapper<TOutputVO> {
  TOutputVO map(IFormNode rootNode);
}