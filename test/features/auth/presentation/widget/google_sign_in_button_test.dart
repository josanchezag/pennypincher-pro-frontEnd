import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/features/auth/presentation/widget/google_sign_in_button.dart';

Future<void> _pump(WidgetTester tester, Widget button) =>
    tester.pumpWidget(MaterialApp(home: Scaffold(body: button)));

void main() {
  testWidgets('calls back when pressed', (tester) async {
    var pressed = 0;
    await _pump(tester, GoogleSignInButton(onPressed: () => pressed++));

    await tester.tap(find.text(GoogleSignInButton.label));

    expect(pressed, 1);
  });

  testWidgets('ignores presses while loading', (tester) async {
    final semantics = tester.ensureSemantics();
    var pressed = 0;
    await _pump(
      tester,
      GoogleSignInButton(onPressed: () => pressed++, isLoading: true),
    );

    await tester.tap(find.text(GoogleSignInButton.label));

    expect(pressed, 0);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(
      find.bySemanticsLabel(RegExp(GoogleSignInButton.progressLabel)),
      findsOneWidget,
    );
    semantics.dispose();
  });
}
