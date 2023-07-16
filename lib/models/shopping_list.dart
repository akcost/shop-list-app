

import 'package:shop_list_app/models/shopping_list_item.dart';

class ShoppingList {
  ShoppingList({
    required this.name,
    required this.shoppingListItems,
  });

  final String name;
  final List<ShoppingListItem> shoppingListItems;
}
