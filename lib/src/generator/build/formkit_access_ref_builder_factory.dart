import 'package:build/build.dart';
import 'package:formkit/src/generator/build/formkit_access_ref_builder.dart';
import 'package:source_gen/source_gen.dart';

Builder formKitAccessRefBuilder(BuilderOptions options) {
  return SharedPartBuilder(
    const [FormKitAccessRefBuilder()],
    'formkit_access_ref',
  );
}