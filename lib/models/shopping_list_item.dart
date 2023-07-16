import 'package:shop_list_app/models/shopping_item.dart';

class ShoppingListItem {
  ShoppingListItem({
    required this.shoppingItem,
    required this.isChecked,
  });

  final ShoppingItem shoppingItem;
  bool isChecked;
}
