import 'package:formkit/src/state/contracts/i_form_state_store.dart';
import 'package:formkit/src/config/contracts/i_form_schema.dart';
import 'package:formkit/src/state/state/form_state.dart';
import 'package:rxdart/subjects.dart';

class FormStateStore implements IFormStateStore<FormStates> {
  final BehaviorSubject<FormStates> _stateSubject;
  final int fieldsCount;
  final IFormSchema config;

  FormStateStore({required this.fieldsCount, required this.config}) : 
    _stateSubject = BehaviorSubject<FormStates>.seeded(
      FormStates(config: config)
    );

  @override
  FormStates get state => _stateSubject.value; 

  @override
  Stream<FormStates> get stream => _stateSubject.stream; 

  @override
  void dispose() {
    _stateSubject.close();
  }
  
  @override
  void reset() {
    _stateSubject.add(FormStates(config: config));
  }
}
