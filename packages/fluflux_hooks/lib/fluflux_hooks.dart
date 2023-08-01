library fluflux_hooks;

import 'package:fluflux/fluflux.dart';
import 'package:flutter/widgets.dart' hide Action;
import 'package:flutter_hooks/flutter_hooks.dart' hide Store;

export 'package:fluflux/fluflux.dart';
export 'package:flutter_hooks/flutter_hooks.dart' hide Store;
export 'package:flutter/widgets.dart' hide Action;

T useStoreState<T>(Store<T> store) {
  final _ = useStream(store);
  return store.state;
}

Store<T> useStoreProvider<T>() {
  final context = useContext();
  final store =
      context.dependOnInheritedWidgetOfExactType<_StoreProvider<T>>()!._store;
  return store;
}

class StoreProviderBuilder<T> extends StatelessWidget {
  final Store<T> _store;
  final Widget Function(BuildContext context, Store<T> store) builder;
  const StoreProviderBuilder({
    super.key,
    required Store<T> store,
    required this.builder,
  }) : _store = store;

  @override
  Widget build(BuildContext context) {
    return _StoreProvider(
      store: _store,
      child: HookBuilder(
        builder: (context) {
          return builder(context, _store);
        },
      ),
    );
  }
}

class _StoreProvider<T> extends InheritedWidget {
  final Store<T> _store;

  const _StoreProvider({
    Key? key,
    required Store<T> store,
    required Widget child,
  })  : _store = store,
        super(key: key, child: child);

  @override
  bool updateShouldNotify(_StoreProvider<T> oldWidget) =>
      _store != oldWidget._store;
}
