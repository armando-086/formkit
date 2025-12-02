import 'package:flutter/material.dart';
import 'package:formkit/src/ui/contracts/i_form_facade.dart';

class FormKitProvider extends InheritedWidget {
  final IFormFacade _formFacade;

  const FormKitProvider({
    required super.child,
    required IFormFacade formFacade,
    super.key,
  }) : _formFacade = formFacade;

  static IFormFacade<TOutputVO>? of<TOutputVO>(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<FormKitProvider>()
        ?._formFacade as IFormFacade<TOutputVO>?;
  }

  @override
  bool updateShouldNotify(FormKitProvider oldWidget) {
    return _formFacade != oldWidget._formFacade;
  }
}