import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/widgets/button_progress_icon.dart';

void main() {
  testWidgets('is a small labelled spinner', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Center(child: ButtonProgressIcon(semanticsLabel: 'Saving')),
      ),
    );

    expect(
      tester.getSize(find.byType(ButtonProgressIcon)),
      const Size.square(ButtonProgressIcon.size),
    );
    final spinner = tester.widget<CircularProgressIndicator>(
      find.byType(CircularProgressIndicator),
    );
    expect(spinner.strokeWidth, ButtonProgressIcon.strokeWidth);
    expect(spinner.semanticsLabel, 'Saving');
  });
}
