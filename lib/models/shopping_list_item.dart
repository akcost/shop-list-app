import 'package:shop_list_app/models/shopping_item.dart';

class ShoppingListItem {
  ShoppingListItem({
    required this.id,
    required this.shoppingItem,
    required this.isChecked,
  });

  final String id;
  final ShoppingItem shoppingItem;
  bool isChecked;
}
