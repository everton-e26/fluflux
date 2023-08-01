import 'dart:async';
import 'package:fluflux/fluflux.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    final store = TestStore();

    test('First Test', () async {
      store.listen((state) {
        print('state listen $state');
      });

      print('increment 1');
      store.dispatch(IncrementAction(1));

      print('increment 3');
      store.dispatch(IncrementAction(3));
      expect(store.state.counter, 4);
    });
  });
}

class TestState {
  final int counter;
  TestState({this.counter = 0});

  TestState copyWith({
    int? counter,
  }) {
    return TestState(
      counter: counter ?? this.counter,
    );
  }

  @override
  String toString() {
    return 'TestState counter: $counter';
  }
}

class TestStore extends Store<TestState> {
  TestStore() : super(initialState: TestState());
}

typedef TestAction = Action<TestState>;

class IncrementAction extends TestAction {
  final int amount;

  IncrementAction(this.amount);

  @override
  FutureOr<TestState?> reduce() {
    return state.copyWith(counter: state.counter + amount);
  }
}
