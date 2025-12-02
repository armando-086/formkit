import 'package:formkit/src/core/contracts/i_service_locator.dart';

class FormKitServiceLocator implements IServiceLocator {
  final Map<Type, Object> _services = {};

  @override
  void register<TContract extends Object, TService extends TContract>(TService service) {
    _services[TContract] = service;
  }

  @override
  TContract resolve<TContract extends Object>() {
    final service = _services[TContract];

    if (service == null) {
      throw StateError(
          'Service not found for contract $TContract. '
          'Please ensure it has been registered using FormKit.registerService().');
    }
    return service as TContract;
  }

  @override
  TContract? tryResolve<TContract extends Object>() {
    return _services[TContract] as TContract?;
  }
}