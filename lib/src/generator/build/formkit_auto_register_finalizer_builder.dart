// ignore: depend_on_referenced_packages
import 'package:build/build.dart';
import 'package:formkit/src/generator/formkit_auto_register_finalizer.dart';
//. =========================================================================
//. 2. Auto-Register Finalizer Builder: Consolida el registro global
//. =========================================================================
Builder formKitAutoRegisterFinalizerBuilder(BuilderOptions options) {
  return FormKitAutoRegisterFinalizer(options);
}
