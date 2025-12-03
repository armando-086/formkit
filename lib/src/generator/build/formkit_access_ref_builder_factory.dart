import 'package:build/build.dart';
import 'package:formkit/src/generator/build/formkit_access_ref_builder.dart';

// **CORRECCIÓN para el error de duplicación y referencia no definida**:
// Se elimina el uso de 'SharedPartBuilder' (que era incorrecto para este tipo de Builder)
// y se devuelve la instancia de la clase FormKitAccessRefBuilder directamente.
Builder formKitAccessRefBuilder(BuilderOptions options) {
  return const FormKitAccessRefBuilder();
}