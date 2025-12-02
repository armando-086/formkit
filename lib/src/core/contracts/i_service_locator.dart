
abstract interface class IServiceLocator {
  void register<TContract extends Object, TService extends TContract>(TService service);
  TContract resolve<TContract extends Object>();
  TContract? tryResolve<TContract extends Object>();
}