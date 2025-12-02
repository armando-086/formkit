import 'package:formkit/src/config/contracts/i_form_schema.dart';

class GroupConfig implements IFormSchema {
  @override
  final String name;

  @override
  final Map<String, IFormSchema> fields;
  final bool Function(dynamic entity)? enableIf;
  final bool Function(dynamic entity)? isVisibleIf;

  GroupConfig({
    required this.name,
    required this.fields,
    this.enableIf, 
    this.isVisibleIf, 
  });
}
