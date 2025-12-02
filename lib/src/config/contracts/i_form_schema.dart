//. Interfaz base para cualquier estructura que pueda contener campos (Form, Group, List).
abstract interface class IFormSchema<TEntity> {
  String get name;
  Map<String, IFormSchema> get fields;
}