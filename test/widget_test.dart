import 'package:flutter_test/flutter_test.dart';

import 'package:rapk/main.dart';

void main() {
  testWidgets('home page shows the two main options', (tester) async {
    await tester.pumpWidget(const ReportApp());

    expect(
      find.text('Geracao de relatorio tecnico de manutencao'),
      findsOneWidget,
    );
    await tester.scrollUntilVisible(find.text('Visualizar dados'), 300);
    expect(find.text('Gerador de\nRelatorios Fotograficos'), findsOneWidget);
    expect(find.text('Visualizar dados'), findsOneWidget);
  });
}
