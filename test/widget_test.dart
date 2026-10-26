import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_camera/main.dart';

void main() {
  testWidgets('App smoke test builds successfully and shows login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const BrasaVivaApp());
    expect(find.textContaining('BRASA'), findsWidgets);
    expect(find.textContaining('MESA 14'), findsWidgets);
  });
}
