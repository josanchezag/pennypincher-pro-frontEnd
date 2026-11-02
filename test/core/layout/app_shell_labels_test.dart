import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/router/app_destination.dart';

import '../../helpers/l10n.dart';
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
    for (final (locale, texts) in [
      (testLocale, l10n),
      (AppLocales.spanish, l10nEs),
    ]) {
      testWidgets(
          'bottom bar labels fit on one line at ${size.width} px '
          'in ${locale.languageCode}', (tester) async {
        await tester.pumpApp(size: size, locale: locale);

        expect(tester.takeException(), isNull);
        for (final destination in AppDestination.mobile) {
          final text = destination.label(texts);
          final label = find.descendant(
            of: find.byType(NavigationBar),
            matching: find.text(text),
          );
          final paragraph = tester.renderObject<RenderParagraph>(label);
          expect(
            paragraph.size.height,
            moreOrLessEquals(_singleLineHeight(paragraph), epsilon: 0.5),
            reason: '"$text" wraps at ${size.width} px',
          );
        }
      });
    }
  }
}
