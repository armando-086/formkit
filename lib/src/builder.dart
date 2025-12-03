// ignore_for_file: depend_on_referenced_packages
import 'package:build/build.dart';
import 'package:formkit/src/generator/formkit_auto_register_collector.dart';
import 'package:formkit/src/generator/formkit_auto_register_finalizer.dart';
import 'package:formkit/src/generator/formkit_generator.dart';
import 'package:source_gen/source_gen.dart';

//. =========================================================================
//. 1. Mapper Builder: Genera Configuración y Acceso
//. =========================================================================
Builder formKitMapperBuilder(BuilderOptions options) {
  return LibraryBuilder(
    const FormKitGenerator(),
    generatedExtension: '.formkit_mapper.dart',
  );
}

//. =========================================================================
//. 2. Auto-Register Finalizer Builder: Consolida el registro global
//. =========================================================================
Builder formKitAutoRegisterFinalizerBuilder(BuilderOptions options) {
  return FormKitAutoRegisterFinalizer(options);
}

//. =========================================================================
//. 3. Auto-Register Collector (PostProcessBuilder)
//. =========================================================================
PostProcessBuilder formKitAutoRegisterBuilder(BuilderOptions options) {
  return FormKitAutoRegisterCollector();
}