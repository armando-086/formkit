import 'package:formkit/src/mapping/contracts/i_data_accessor.dart';
import 'package:formkit/src/node/contracts/i_form_node.dart';
import 'package:formkit/src/mapping/contracts/i_form_tree_hydration.dart';
//. =============================================================
//. Implementación placeholder del servicio de hidratación (IFormHydrator).
//. Usado para inicializar FormKitCoreEngine cuando no se provee uno.
//. =============================================================

class DefaultFormHydrator implements IFormTreeHydration {
  @override
  void hydrate<TEntity>(
      IFormNode rootNode, TEntity entity, IDataAccessor<TEntity> accessor) {}
}