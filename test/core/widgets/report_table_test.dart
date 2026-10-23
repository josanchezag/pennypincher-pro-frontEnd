import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_theme.dart';
import 'package:pennypincher_pro/core/widgets/report_table.dart';

import '../../helpers/load_fonts.dart';

const List<String> _columns = ['Month', 'Assets', 'Liabilities', 'Net', 'Δ'];

const List<ReportRow> _rows = [
  ReportRow(
    cells: [
      ReportCell('Oct 2026'),
      ReportCell(r'$ 1.990.000.000'),
      ReportCell(r'$ 120.000.000'),
      ReportCell(r'$ 1.870.000.000'),
      ReportCell(r'-$ 1.000.000', color: AppColors.error),
    ],
    highlight: 'Best',
  ),
];

void main() {
  setUpAll(loadAppFonts);

  Future<void> pumpTable(WidgetTester tester, double width) async {
    tester.view.physicalSize = Size(width, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: const Scaffold(
          body: SingleChildScrollView(
            child: ReportTable(columns: _columns, rows: _rows),
          ),
        ),
      ),
    );
  }

  for (final width in [390.0, 656.0, 960.0, 1200.0]) {
    testWidgets('keeps the last column on screen at ${width.toInt()} px',
        (tester) async {
      await pumpTable(tester, width);

      final last = tester.getRect(find.text(r'-$ 1.000.000'));
      expect(last.right, lessThanOrEqualTo(width));
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('switches to cards when the columns would not fit',
      (tester) async {
    const table = ReportTable(columns: _columns, rows: _rows);
    final needed = table.requiredWidth(TextScaler.noScaling);

    await pumpTable(tester, needed.floorToDouble() - 1);
    expect(find.byType(DataTable), findsNothing);

    await pumpTable(tester, needed.ceilToDouble());
    expect(find.byType(DataTable), findsOneWidget);
    expect(find.text('BEST'), findsOneWidget);
  });
}
