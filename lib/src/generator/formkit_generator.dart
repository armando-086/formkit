// ignore_for_file: depend_on_referenced_packages, unnecessary_import
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:formkit/src/generator/utils/field_info.dart';
import 'package:formkit/src/generator/utils/get_vo_info.dart';
import 'package:source_gen/source_gen.dart';

//. El TypeChecker debe usar la nueva anotación
const _formKitTargetChecker = TypeChecker.fromUrl(
  'package:formkit/src/generator/annotation/formkit_target.dart#FormKitTarget', 
);

class FormKitGenerator extends Generator {
  const FormKitGenerator();
  
  @override
  Future<String?> generate(LibraryReader library, BuildStep buildStep) async {
    // Buscar clases anotadas con @FormKitTarget
    for (final element in library.classes) {
      if (!_formKitTargetChecker.hasAnnotationOfExact(element)) continue;

      // Procesar esta clase
      return _generateFor(element, buildStep);
    }

    return null; // Nada que generar
  }

  Future<String?> _generateFor(
    ClassElement outputClass,
    BuildStep buildStep,
  ) async {
    final String? outputClassName = outputClass.name;
    final String generatedConfigName = '\$${outputClassName}FormConfig';
    final String generatedMapperName = '_${outputClassName}Mapper';
    final String generatedAccessName = '${outputClassName}FormKit'; // Nombre simplificado para el desarrollador

    final String mapperContract = 'IFormMapper<$outputClassName>';
    final String accessContract = 'IFormKitAccess<$outputClassName>';

    final fields = outputClass.fields
        .where((f) => !f.isStatic && !f.isPrivate && !f.isSynthetic)
        .toList();

    if (fields.isEmpty) {
      throw InvalidGenerationSourceError(
        'Class $outputClassName must have fields to map.',
        element: outputClass,
      );
    }

    final buffer = StringBuffer();

    // --------------------------------------------------------------
    // HEADERS
    // --------------------------------------------------------------

    buffer.writeln("// GENERATED CODE - DO NOT MODIFY BY HAND");
    buffer.writeln("// ignore_for_file: depend_on_referenced_packages, unnecessary_import");
    buffer.writeln("import 'package:flutter/widgets.dart';");
    buffer.writeln("import 'package:formkit/formkit.dart';");
    buffer.writeln("import 'package:formkit/src/flutter/core/contracts/icontroller_factory.dart';");
    buffer.writeln("import 'package:formkit/src/flutter/core/contracts/iformkit_access.dart';");
    buffer.writeln("import 'package:formkit/src/flutter/core/field_controller.dart';");

    // Importar entidad original
    final packageName = buildStep.inputId.package;
    final inputPath = buildStep.inputId.path;
    final relativePath = inputPath.startsWith('lib/')
        ? inputPath.substring(4)
        : inputPath;

    buffer.writeln("import 'package:$packageName/$relativePath';");
    buffer.writeln("");

    // --------------------------------------------------------------
    // 1. CONFIG
    // --------------------------------------------------------------

    buffer.writeln('/// Configuración de formulario generada para $outputClassName');
    buffer.writeln('class $generatedConfigName implements IFormSchema<$outputClassName> {'); // IFormSchema en lugar de IFormConfig
    buffer.writeln('  const $generatedConfigName();');
    buffer.writeln('');
    buffer.writeln('  @override');
    buffer.writeln("  String get name => '${outputClassName?.toLowerCase()}';");
    buffer.writeln('');
    buffer.writeln('  @override');
    buffer.writeln('  Map<String, IFormSchema> get fields => {');

    for (final field in fields) {
      final fieldName = field.name;
      final FieldInfo info = getVoInfo(field);

      // Usamos el fromValue estático del VO como valueConverter, según v12.
      final String converter;
      final String voType = info.voType;
      final String primitiveType = info.primitiveType;
      
      if (info.isValueObject) {
         // Uso directo del método estático fromValue, asumiendo que el VO tiene la lógica.
         // Esto simplifica la configuración al Core Engine.
         converter = 
            'ValueObjectConverter<$primitiveType, $voType>((p) => $voType.fromValue(p as $primitiveType))'; 
      } else {
        converter = 'DefaultValueConverter<$voType>()';
      }

      buffer.writeln("    '$fieldName': FieldConfig<$primitiveType, $voType>(");
      buffer.writeln("      name: '$fieldName',");
      buffer.writeln("      valueConverter: $converter,");
      // Nota: initialValue no se puede inferir aquí sin el entityLoader, 
      // así que se usa null para no requerir un rawValue inexistente.
      buffer.writeln("      initialValue: null,"); 
      buffer.writeln('    ),');
    }

    buffer.writeln('  };');
    buffer.writeln('}');
    buffer.writeln('');

    // --------------------------------------------------------------
    // 2. MAPPER
    // --------------------------------------------------------------

    // Nota: Este mapper no se usa en v12 si el VO ya está mapeando. 
    // Lo simplificaremos para generar la DTO final.
    buffer.writeln('/// Mapper generado para $outputClassName (Uso interno de FormKit)');
    buffer.writeln('class $generatedMapperName implements $mapperContract {');
    buffer.writeln('  const $generatedMapperName();');
    buffer.writeln('');

    buffer.writeln('  @override');
    buffer.writeln('  $outputClassName map(Map<String, dynamic> rawValue) {');
    buffer.writeln('    return $outputClassName(');

    for (final field in fields) {
      final name = field.name;
      final info = getVoInfo(field);

      final raw = "rawValue['$name']";
      final vo = info.voType;

      // El Core Engine ya habrá convertido los valores al tipo VO.
      buffer.writeln('      $name: $raw as $vo,');
    }

    buffer.writeln('    );');
    buffer.writeln('  }');
    buffer.writeln('}');
    buffer.writeln('');

    // --------------------------------------------------------------
    // 3. ACCESS
    // --------------------------------------------------------------

    buffer.writeln('/// Acceso generado para $outputClassName (Clase que el desarrollador usa)');
    buffer.writeln('class $generatedAccessName implements $accessContract {');
    buffer.writeln('  final IControllerFactory _controllerFactory;');
    buffer.writeln('  $generatedAccessName(this._controllerFactory);');
    buffer.writeln('');

    buffer.writeln('  @override');
    buffer.writeln('  GlobalKey<FormState> get formKey => _controllerFactory.formKey;');
    buffer.writeln('');

    // Generar controladores fuertemente tipados
    for (final field in fields) {
      final name = field.name;
      final info = getVoInfo(field);

      final ctype = 'FieldController<${info.primitiveType}, ${info.voType}>';

      buffer.writeln('  $ctype get ${name}Controller {'); // Agregando sufijo 'Controller' para claridad
      buffer.writeln("    final controller = _controllerFactory.getController('$name');");
      buffer.writeln('    if (controller is! $ctype) {');
      buffer.writeln("      throw StateError('Controller $name is not type $ctype');");
      buffer.writeln('    }');
      buffer.writeln('    return controller;');
      buffer.writeln('  }');
      buffer.writeln('');
    }
    
    // Método simplificado para el BLoC (Punto 5.3)
    buffer.writeln('  Future<$outputClassName?> validatedFlush() async {');
    buffer.writeln("    return _controllerFactory.validatedFlush<$outputClassName>();");
    buffer.writeln('  }');
    buffer.writeln('');

    buffer.writeln('  @override');
    buffer.writeln('  Map<String, IFieldController> get allControllers => _controllerFactory.allControllers;');
    buffer.writeln('');
    
    buffer.writeln('  @override');
    buffer.writeln('  IFieldController<P, V>? getController<P, V>(String fieldName) {');
    buffer.writeln('    final c = _controllerFactory.getController(fieldName);');
    buffer.writeln('    return c is IFieldController<P, V> ? c : null;');
    buffer.writeln('  }');

    buffer.writeln('}');
    buffer.writeln('');

    // --------------------------------------------------------------
    // 4. .formkit_access_ref (Para el auto-registro)
    // --------------------------------------------------------------

    final refId = buildStep.inputId.changeExtension('.formkit_access_ref');

    final ref = StringBuffer();
    ref.writeln('FormKitAccess:$generatedAccessName');
    ref.writeln('Entity:$outputClassName');
    ref.writeln('Path:$relativePath');

    await buildStep.writeAsString(refId, ref.toString());

    return buffer.toString();
  }
}