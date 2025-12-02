import 'package:formkit/src/ui/contracts/i_controller_factory.dart';
import 'package:formkit/src/ui/contracts/i_form_facade.dart';

abstract interface class ICompositeFormFacade<TOutputVO> implements IFormFacade<TOutputVO> {
  IControllerFactory get controllerFactory;
}