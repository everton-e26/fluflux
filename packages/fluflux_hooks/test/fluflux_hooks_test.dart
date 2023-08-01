import 'package:flutter/widgets.dart' hide Action;
import 'package:flutter_test/flutter_test.dart';
import 'package:fluflux_hooks/fluflux_hooks.dart';

void main() {
  final store = TestStore();

  testWidgets('simple build', (tester) async {
    await tester.pumpWidget(
      HookBuilder(builder: (context) {
        final state = useStoreState(store);
        return Text('${state.counter}', textDirection: TextDirection.ltr);
      }),
    );
    expect(find.text('0'), findsOneWidget);
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
