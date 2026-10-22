import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/router/app_destination.dart';

import '../../helpers/load_fonts.dart';
import '../../helpers/pump_app.dart';

const List<Size> _narrowPhones = [Size(360, 740), TestViewports.mobile];

double _singleLineHeight(RenderParagraph paragraph) {
  final painter = TextPainter(
    text: paragraph.text,
    textDirection: TextDirection.ltr,
    textScaler: paragraph.textScaler,
  )..layout();
  final height = painter.height;
  painter.dispose();
  return height;
}

void main() {
  setUpAll(loadAppFonts);

  for (final size in _narrowPhones) {
    testWidgets('bottom bar labels fit on one line at ${size.width} px',
        (tester) async {
      await tester.pumpApp(size: size);

      expect(tester.takeException(), isNull);
      for (final destination in AppDestination.mobile) {
        final label = find.descendant(
          of: find.byType(NavigationBar),
          matching: find.text(destination.label),
        );
        final paragraph = tester.renderObject<RenderParagraph>(label);
        expect(
          paragraph.size.height,
          moreOrLessEquals(_singleLineHeight(paragraph), epsilon: 0.5),
          reason: '"${destination.label}" wraps at ${size.width} px',
        );
      }
    });
  }
}
