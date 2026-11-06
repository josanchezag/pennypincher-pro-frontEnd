import 'package:flutter/widgets.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/utils/app_currency.dart';
import 'package:pennypincher_pro/core/utils/money_formatter.dart';

/// Gives the widgets below it the [MoneyFormatter] of the user's currency
/// and the interface language. The app puts one above every screen, so a
/// change of currency or language redraws every amount at once.
class MoneyFormatScope extends InheritedWidget {
  const MoneyFormatScope({
    required this.formatter,
    required super.child,
    super.key,
  });

  final MoneyFormatter formatter;

  /// The formatter above [context]. Without a scope, as in widget tests of
  /// a single screen, amounts are in Colombian pesos in the language of
  /// the surrounding [Localizations].
  static MoneyFormatter of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<MoneyFormatScope>();
    if (scope != null) {
      return scope.formatter;
    }
    final language = Localizations.maybeLocaleOf(context)?.languageCode;
    return MoneyFormatter.of(
      AppCurrency.fallback,
      language ?? AppLocales.fallback.languageCode,
    );
  }

  @override
  bool updateShouldNotify(MoneyFormatScope oldWidget) =>
      !identical(formatter, oldWidget.formatter);
}

extension MoneyFormatContext on BuildContext {
  /// Formats amounts in the user's currency and the interface language.
  MoneyFormatter get money => MoneyFormatScope.of(this);
}
