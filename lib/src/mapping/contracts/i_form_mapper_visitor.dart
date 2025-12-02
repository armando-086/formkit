import 'package:formkit/src/node/contracts/i_node_visitor.dart';
//. =============================================================
//. Contrato para el Visitor específico del proceso de mapeo.
//. =============================================================

abstract interface class IFormMapperVisitor implements INodeVisitor {
  TOutputVO getMapResult<TOutputVO>();
}
