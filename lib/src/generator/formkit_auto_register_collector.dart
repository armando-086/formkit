import 'package:build/build.dart';

class FormKitAutoRegisterCollector implements PostProcessBuilder {
  static const outputFilePath = 'lib/formkit_auto_register.dart';

  @override
  Iterable<String> get inputExtensions => const ['.formkit_access_ref'];

  @override
  Future<void> build(PostProcessBuildStep buildStep) async {
  }
}