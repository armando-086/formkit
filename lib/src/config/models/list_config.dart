import 'package:formkit/src/config/contracts/i_form_schema.dart';

class ListConfig<TItem> implements IFormSchema {
  @override
  final String name;
  final IFormSchema itemSchema; 

  ListConfig({
    required this.name,
    required this.itemSchema,
  });

  @override
  Map<String, IFormSchema> get fields => {};
}