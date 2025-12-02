import 'package:formkit/src/ui/contracts/i_text_field_controller.dart';

/// Extensión para acceso seguro a controladores con mensajes de error claros.
extension FormKitControllerExtension
    on ITextFieldController<String, dynamic>? {
  /// Garantiza que el controller existe o lanza una excepción descriptiva.
  ITextFieldController<String, dynamic> getOrThrow({
    required String fieldId,
    String? hint,
  }) {
    if (this == null) {
      throw StateError(
        'FormKit Controller not found for field "$fieldId".\n'
        'Make sure FormKitCore.createForm() has been called BEFORE accessing controllers.\n'
        '${hint != null ? 'Hint: $hint' : ''}\n\n'
        'Correct flow:\n'
        '1. FormKitCore.initializeCore()\n'
        '2. FormKitFacade.initializeFlutter()\n'
        '3. FormKitCore.createForm(schema: yourSchema)\n'
        '4. THEN access FormKitFacade.getController()',
      );
    }
    return this!;
  }
}
