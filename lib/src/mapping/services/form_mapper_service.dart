import 'package:formkit/src/mapping/contracts/i_form_mapper.dart';
import 'package:formkit/src/exceptions/formkit_structure_exception.dart';
import 'package:formkit/src/node/node/group_node.dart';
import 'package:formkit/src/node/contracts/i_form_node.dart';
import 'package:formkit/src/core/engine/node_walker.dart';
import 'package:formkit/src/mapping/visitor/form_mapper_visitor.dart';
//. =============================================================
//. Implementación concreta del IFormMapper.
//. Coordina el NodeWalker y el FormMapperVisitor.
//. TOutputVO: Tipo del Value Object final (VO) a generar.
//. =============================================================
class FormMapperService<TOutputVO> implements IFormMapper<TOutputVO> {
  final NodeWalker _walker;
  final FormMapperVisitor _visitor;

  FormMapperService(this._walker) : _visitor = FormMapperVisitor();

  @override
  TOutputVO map(IFormNode rootNode) {

    if (rootNode is! GroupNode) {
      throw FormKitStructureException(
          'Root node must be a GroupNode to perform mapping.');
    }

    _walker.walk(rootNode, _visitor);

    return _visitor.getMapResult<TOutputVO>();
  }
}
