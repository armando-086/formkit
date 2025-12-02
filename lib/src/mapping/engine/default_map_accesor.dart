import 'package:formkit/src/mapping/contracts/i_data_accessor.dart';

//. =============================================================
//. Implementación por defecto de IDataAccessor para hidratación desde Map.
//. =============================================================
class DefaultMapAccessor implements IDataAccessor<Map<String, dynamic>> {
  @override
  dynamic getValue(Map<String, dynamic> entity, String key) {
    return entity[key];
  }
}