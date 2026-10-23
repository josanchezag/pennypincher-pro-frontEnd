import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_theme.dart';
import 'package:pennypincher_pro/core/time/time_range.dart';
import 'package:pennypincher_pro/core/widgets/time_range_selector.dart';

void main() {
  testWidgets('shows the selected range in white on brand blue',
      (tester) async {
    TimeRange? picked;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: Scaffold(
          body: TimeRangeSelector(
            selected: TimeRange.oneYear,
            onChanged: (range) => picked = range,
          ),
        ),
      ),
    );

    final style = TimeRangeSelector.style;
    const selected = {WidgetState.selected};
    expect(style.backgroundColor?.resolve(selected), AppColors.brandPrimary);
    expect(style.foregroundColor?.resolve(selected), AppColors.textOnBrand);
    expect(style.foregroundColor?.resolve({}), AppColors.textPrimary);
    final text = tester.widget<DefaultTextStyle>(
      find
          .ancestor(
            of: find.text(TimeRange.oneYear.label),
            matching: find.byType(DefaultTextStyle),
          )
          .first,
    );
    expect(text.style.color, AppColors.textOnBrand);

    await tester.tap(find.text(TimeRange.all.label));
    expect(picked, TimeRange.all);
  });
}
