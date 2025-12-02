import 'package:formkit/src/mapping/contracts/i_data_accessor.dart';

class FakeDataAccessor<TEntity> implements IDataAccessor<TEntity> {
  //. Mapa de datos que simula la entidad
  final Map<String, dynamic> data;

  FakeDataAccessor(this.data);

  @override
  dynamic getValue(TEntity entity, String key) {
    //. El fake ignora la entidad real (TEntity) y solo usa la clave
    return data[key];
  }
}