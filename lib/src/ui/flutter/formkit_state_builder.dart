import 'package:flutter/material.dart';
import 'package:formkit/src/ui/contracts/i_field_controller.dart';
import 'package:formkit/src/state/state/field_state.dart';

class FormKitStateBuilder extends StatelessWidget {
  final IFieldController fieldController;
  final Widget Function(BuildContext context, FieldState state) builder;

  const FormKitStateBuilder({
    super.key,
    required this.fieldController,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final FieldState initialData = fieldController.state;
    
    return StreamBuilder<FieldState>(
      stream: fieldController.stateStream, 
      initialData: initialData,
      builder: (context, snapshot) {
        final FieldState currentState = snapshot.data!;
        return builder(context, currentState);
      },
    );
  }
}