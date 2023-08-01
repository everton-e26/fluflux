import 'dart:async';

abstract class Store<T> extends Stream<T> {
  Store({required T initialState}) : _state = initialState {
    _stateController.add(_state);
  }
  T _state;
  T get state => _state;
  final _stateController = StreamController<T>.broadcast(sync: true);

  FutureOr<void> dispatch(Action<T> action) async {
    action._setStore(this);
    final result = action.reduce();
    final newState = result is Future ? await result : result;
    if (newState != null) {
      _state = newState;
      _stateController.add(_state);
    }
  }

  @override
  StreamSubscription<T> listen(void Function(T event)? onData,
          {Function? onError, void Function()? onDone, bool? cancelOnError}) =>
      _stateController.stream.listen(
        onData,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError,
      );
}

abstract class Action<T> {
  late final Store<T> _store;
  Store<T> get store => _store;
  void _setStore(Store<T> store) {
    _store = store;
  }

  T get state => store.state;

  FutureOr<T?> reduce();

  FutureOr<void> dispatch(Action<T> action) async {
    await _store.dispatch(action);
  }
}
