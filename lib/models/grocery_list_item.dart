import 'package:shop_list_app/models/grocery_item.dart';

class GroceryListItem {
  GroceryListItem({
    required this.groceryItem,
    required this.isChecked,
  });

  final GroceryItem groceryItem;
  bool isChecked;
}
