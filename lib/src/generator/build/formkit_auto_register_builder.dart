// ignore: depend_on_referenced_packages
import 'package:build/build.dart';
import 'package:formkit/src/generator/formkit_auto_register_collector.dart';

//. =========================================================================
//. 3. Auto-Register Collector (PostProcessBuilder)
//. =========================================================================
PostProcessBuilder formKitAutoRegisterBuilder(BuilderOptions options) {
  return FormKitAutoRegisterCollector();
}