import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/widgets/responsive_card_row.dart';

void main() {
  Future<void> pump(WidgetTester tester, double width) => tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: width,
              child: const ResponsiveCardRow(
                children: [
                  SizedBox(key: Key('a'), height: 40),
                  SizedBox(key: Key('b'), height: 80),
                ],
              ),
            ),
          ),
        ),
      );

  testWidgets('stacks the cards on mobile', (tester) async {
    await pump(tester, 375);

    final first = tester.getRect(find.byKey(const Key('a')));
    final second = tester.getRect(find.byKey(const Key('b')));
    expect(second.top, greaterThan(first.bottom));
    expect(first.width, 375);
  });

  testWidgets('puts the cards side by side with one height from tablet up',
      (tester) async {
    await pump(tester, 800);

    final first = tester.getRect(find.byKey(const Key('a')));
    final second = tester.getRect(find.byKey(const Key('b')));
    expect(second.top, first.top);
    expect(second.left, greaterThan(first.right));
    expect(first.height, second.height);
  });
}
