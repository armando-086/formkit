import 'package:formkit/src/config/contracts/i_form_schema.dart';
import 'package:meta/meta.dart';

@immutable
final class FormSchemaImpl<TEntity> implements IFormSchema<TEntity> {
  @override
  final String name;
  @override
  final Map<String, IFormSchema> fields;
  final TEntity Function(Map<String, dynamic> formModel)? entityFactory;
  final Map<String, dynamic> Function(TEntity entity)? entityLoader;

  const FormSchemaImpl({
    required this.name,
    required this.fields,
    this.entityFactory,
    this.entityLoader,
  });
}