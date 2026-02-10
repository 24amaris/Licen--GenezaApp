import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('GenezaApp loads and shows home screen title',
      (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const GenezaApp());

    // Verificăm dacă apare titlul paginii
    expect(find.text('Geneza App'), findsOneWidget);

    // Verificăm dacă widget-ul HomeScreen a încărcat și textul cu Firebase
    expect(find.textContaining('Firebase este conectat'),
        findsOneWidget);
  });
}
