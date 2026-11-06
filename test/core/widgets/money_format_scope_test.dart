import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/utils/app_currency.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/utils/money_formatter.dart';
import 'package:pennypincher_pro/core/widgets/money_format_scope.dart';

import '../../helpers/l10n.dart';

/// Shows [amount] as `context.money` writes it.
class _Amount extends StatelessWidget {
  const _Amount(this.amount);

  final Money amount;

  @override
  Widget build(BuildContext context) => Text(context.money.format(amount));
}

void main() {
  const amount = Money.fromCents(123456750);

  testWidgets('formats with the formatter of the scope', (tester) async {
    await tester.pumpWidget(
      localizedApp(
        home: MoneyFormatScope(
          formatter: MoneyFormatter.of(AppCurrency.usd, 'en'),
          child: const _Amount(amount),
        ),
      ),
    );

    expect(find.text(r'$1,234,567.50'), findsOneWidget);
  });

  testWidgets('uses pesos in the surrounding language without a scope',
      (tester) async {
    await tester.pumpWidget(
      localizedApp(home: const _Amount(amount), locale: AppLocales.spanish),
    );

    expect(find.text('\$ 1.234.568'), findsOneWidget);
  });

  testWidgets('redraws the amounts when the formatter changes', (tester) async {
    final formatter = ValueNotifier(MoneyFormatter.of(AppCurrency.cop, 'es'));
    addTearDown(formatter.dispose);
    await tester.pumpWidget(
      localizedApp(
        home: ValueListenableBuilder<MoneyFormatter>(
          valueListenable: formatter,
          builder: (_, value, __) => MoneyFormatScope(
            formatter: value,
            child: const _Amount(amount),
          ),
        ),
      ),
    );

    formatter.value = MoneyFormatter.of(AppCurrency.eur, 'es');
    await tester.pump();

    expect(find.text('1.234.567,50 €'), findsOneWidget);
  });
}
