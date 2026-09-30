import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_camera/main.dart';

void main() {
  testWidgets('App smoke test builds successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const BrasaVivaApp());
    expect(find.text('Cardápio'), findsWidgets);
  });
}
