// ignore_for_file: depend_on_referenced_packages
import 'package:build/build.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:formkit/src/generator/annotation/formkit_target.dart';

const formKitTargetChecker = TypeChecker.fromUrl(
  'package:formkit/src/generator/annotation/formkit_target.dart#FormKitTarget',
);

class FormKitAccessRefBuilder extends GeneratorForAnnotation<FormKitTarget> {
  const FormKitAccessRefBuilder();

  @override
  Future<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    if (element is! ClassElement) {
      return '';
    }

    final ClassElement outputClass = element;
    final String? outputClassName = outputClass.name;
    final String generatedAccessName = '${outputClassName}FormKit';

    // Importar entidad original (calculando el path)
    final inputPath = buildStep.inputId.path;
    final relativePath = inputPath.startsWith('lib/')
        ? inputPath.substring(4)
        : inputPath;

    // Escribir el contenido del archivo de referencia (este es el output)
    final ref = StringBuffer();
    ref.writeln('FormKitAccess:$generatedAccessName');
    ref.writeln('Entity:$outputClassName');
    ref.writeln('Path:$relativePath');
    
    // Devolver el contenido. SourceGen se encarga de escribir el archivo.
    return ref.toString(); 
  }
}