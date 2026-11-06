import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/entity/ant_expense_entity.dart';

/// Name and icon of every [AntExpenseCategory].
extension AntExpenseCategoryView on AntExpenseCategory {
  String label(AppLocalizations l10n) => switch (this) {
        AntExpenseCategory.coffeeAndDrinks => l10n.antCategoryCoffeeAndDrinks,
        AntExpenseCategory.snacksAndSweets => l10n.antCategorySnacksAndSweets,
        AntExpenseCategory.fastFood => l10n.antCategoryFastFood,
        AntExpenseCategory.transport => l10n.antCategoryTransport,
        AntExpenseCategory.deliveryAndTips => l10n.antCategoryDeliveryAndTips,
        AntExpenseCategory.appsAndSubscriptions =>
          l10n.antCategoryAppsAndSubscriptions,
        AntExpenseCategory.impulsePurchases => l10n.antCategoryImpulsePurchases,
        AntExpenseCategory.other => l10n.antCategoryOther,
      };

  IconData get icon => switch (this) {
        AntExpenseCategory.coffeeAndDrinks => Icons.local_cafe_outlined,
        AntExpenseCategory.snacksAndSweets => Icons.cookie_outlined,
        AntExpenseCategory.fastFood => Icons.fastfood_outlined,
        AntExpenseCategory.transport => Icons.local_taxi_outlined,
        AntExpenseCategory.deliveryAndTips => Icons.delivery_dining_outlined,
        AntExpenseCategory.appsAndSubscriptions => Icons.apps_outlined,
        AntExpenseCategory.impulsePurchases => Icons.shopping_cart_outlined,
        AntExpenseCategory.other => Icons.more_horiz,
      };
}

/// How the interface names an ant expense: its description, or its
/// category when it has none.
extension AntExpenseView on AntExpense {
  String title(AppLocalizations l10n) => description ?? category.label(l10n);
}
