// ignore_for_file: depend_on_referenced_packages
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:formkit/src/generator/formkit_generator.dart';
//. =========================================================================
//. 1. Mapper Builder: Genera Configuración y Acceso
//. =========================================================================
Builder formKitMapperBuilder(BuilderOptions options) {
  return LibraryBuilder(
    const FormKitGenerator(),
    generatedExtension: '.formkit_mapper.dart',
  );
}
