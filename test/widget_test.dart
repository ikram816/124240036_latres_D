import 'package:flutter_test/flutter_test.dart';
import 'package:latres_ikram_d/main.dart';

void main() {
  testWidgets('App basic initialization smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(MyApp), findsOneWidget);
  });
}
