import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';

/// Text of one cell of a [ReportTable], in [color] when given.
class ReportCell {
  const ReportCell(this.text, {this.color});

  final String text;
  final Color? color;
}

/// One row of a [ReportTable]: its first cell names it (such as the
/// month). A [highlight] label, such as `Best`, marks and highlights it.
class ReportRow {
  const ReportRow({required this.cells, this.highlight});

  final List<ReportCell> cells;
  final String? highlight;
}

/// Table of a report: a data table when all of its columns fit the width
/// available, and one compact card per row otherwise, so the last column
/// is never hidden off screen.
class ReportTable extends StatelessWidget {
  const ReportTable({required this.columns, required this.rows, super.key});

  /// Headings; the first one is that of the row names.
  final List<String> columns;
  final List<ReportRow> rows;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) =>
          constraints.maxWidth < requiredWidth(MediaQuery.textScalerOf(context))
              ? _CompactRows(columns: columns, rows: rows)
              : _WideTable(
                  columns: columns,
                  rows: rows,
                  minWidth: constraints.maxWidth,
                ),
    );
  }

  /// Width the data table takes to show every cell on one line.
  double requiredWidth(TextScaler scaler) {
    var total = _WideTable.horizontalMargin * 2 +
        _WideTable.columnSpacing * (columns.length - 1);
    for (final (index, heading) in columns.indexed) {
      var widest = _textWidth(heading, AppTypography.label, scaler);
      for (final row in rows) {
        widest = math.max(widest, _cellWidth(row, index, scaler));
      }
      total += widest;
    }
    return total;
  }

  static double _cellWidth(ReportRow row, int index, TextScaler scaler) {
    if (index > 0) {
      final cell = row.cells[index].text;
      return _textWidth(cell, _WideTable.cellStyle, scaler);
    }
    final name =
        _textWidth(row.cells.first.text, AppTypography.bodyLarge, scaler);
    final highlight = row.highlight;
    return highlight == null
        ? name
        : name + AppSpacing.xs + _Highlight.widthOf(highlight, scaler);
  }

  static double _textWidth(String text, TextStyle style, TextScaler scaler) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      textScaler: scaler,
    )..layout();
    final width = painter.width;
    painter.dispose();
    return width.ceilToDouble();
  }
}

class _Highlight extends StatelessWidget {
  const _Highlight({required this.label});

  static const double horizontalPadding = AppSpacing.xs;

  final String label;

  static double widthOf(String label, TextScaler scaler) =>
      ReportTable._textWidth(label.toUpperCase(), _style, scaler) +
      horizontalPadding * 2;

  static final TextStyle _style =
      AppTypography.label.copyWith(color: AppColors.backgroundPrimary);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: AppSpacing.xxs / 2,
      ),
      decoration: const BoxDecoration(
        color: AppColors.accentGold,
        borderRadius:
            BorderRadius.all(Radius.circular(AppSpacing.radiusButton)),
      ),
      child: Text(
        label.toUpperCase(),
        style: _style,
      ),
    );
  }
}

/// Name of a row with its highlight label, if any.
class _RowName extends StatelessWidget {
  const _RowName({required this.row, required this.style});

  final ReportRow row;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final highlight = row.highlight;
    return Wrap(
      spacing: AppSpacing.xs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(row.cells.first.text, style: style),
        if (highlight != null) _Highlight(label: highlight),
      ],
    );
  }
}

class _WideTable extends StatelessWidget {
  const _WideTable({
    required this.columns,
    required this.rows,
    required this.minWidth,
  });

  static const double columnSpacing = AppSpacing.lg;
  static const double horizontalMargin = AppSpacing.sm;

  /// Amounts in the small mono size, so a year of ten-digit amounts fits
  /// a desktop screen.
  static const TextStyle cellStyle = AppTypography.monoSmall;

  final List<String> columns;
  final List<ReportRow> rows;
  final double minWidth;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: minWidth),
        child: DataTable(
          columnSpacing: columnSpacing,
          horizontalMargin: horizontalMargin,
          headingTextStyle: AppTypography.label,
          columns: [
            for (final (index, column) in columns.indexed)
              DataColumn(label: Text(column), numeric: index > 0),
          ],
          rows: [for (final row in rows) _row(row)],
        ),
      ),
    );
  }

  static DataRow _row(ReportRow row) => DataRow(
        color: row.highlight == null
            ? null
            : const WidgetStatePropertyAll(AppColors.backgroundTertiary),
        cells: [
          DataCell(_RowName(row: row, style: AppTypography.bodyLarge)),
          for (final cell in row.cells.skip(1))
            DataCell(
              Text(
                cell.text,
                style: cellStyle.copyWith(color: cell.color),
              ),
            ),
        ],
      );
}

class _CompactRows extends StatelessWidget {
  const _CompactRows({required this.columns, required this.rows});

  final List<String> columns;
  final List<ReportRow> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final row in rows)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _CompactRow(columns: columns, row: row),
          ),
      ],
    );
  }
}

class _CompactRow extends StatelessWidget {
  const _CompactRow({required this.columns, required this.row});

  final List<String> columns;
  final ReportRow row;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: row.highlight == null ? null : AppColors.backgroundTertiary,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _RowName(row: row, style: AppTypography.heading3),
            const SizedBox(height: AppSpacing.xs),
            for (var index = 1; index < row.cells.length; index++)
              _CompactCell(label: columns[index], cell: row.cells[index]),
          ],
        ),
      ),
    );
  }
}

class _CompactCell extends StatelessWidget {
  const _CompactCell({required this.label, required this.cell});

  final String label;
  final ReportCell cell;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTypography.bodyMedium)),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Text(
                cell.text,
                style: AppTypography.monoMedium.copyWith(color: cell.color),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
