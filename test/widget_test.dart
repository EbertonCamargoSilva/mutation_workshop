import 'package:flutter_test/flutter_test.dart';

import 'package:todo_list_app/main.dart';

void main() {
  testWidgets('App should render Todo List screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Todo List'), findsOneWidget);
  });
}
