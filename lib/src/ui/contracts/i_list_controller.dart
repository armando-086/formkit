import 'package:formkit/src/core/contracts/i_disposable.dart';
import 'package:formkit/src/state/state/list_state.dart';

abstract interface class IListController<TItem> implements IDisposable {
  Stream<ListState> get stateStream;
  void addItem({TItem? initialValue});
  void removeItem(int index);
  void clear();
}
