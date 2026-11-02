import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/features/auth/presentation/widget/google_sign_in_button.dart';

import '../../../../helpers/l10n.dart';

Future<void> _pump(WidgetTester tester, Widget button) =>
    tester.pumpWidget(localizedApp(home: Scaffold(body: button)));

void main() {
  testWidgets('calls back when pressed', (tester) async {
    var pressed = 0;
    await _pump(tester, GoogleSignInButton(onPressed: () => pressed++));

    await tester.tap(find.text(l10n.signInWithGoogle));

    expect(pressed, 1);
  });

  testWidgets('ignores presses while loading', (tester) async {
    final semantics = tester.ensureSemantics();
    var pressed = 0;
    await _pump(
      tester,
      GoogleSignInButton(onPressed: () => pressed++, isLoading: true),
    );

    await tester.tap(find.text(l10n.signInWithGoogle));

    expect(pressed, 0);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(
      find.bySemanticsLabel(RegExp(l10n.signingIn)),
      findsOneWidget,
    );
    semantics.dispose();
  });
}
