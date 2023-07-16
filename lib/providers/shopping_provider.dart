import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_list_app/models/shopping_list.dart';

class ShoppingNotifier extends StateNotifier<List<ShoppingList>> {
  ShoppingNotifier() : super([]);

  void addShoppingList(ShoppingList shoppingList) {
    state = [...state, shoppingList];
  }

  void removeShoppingList(String name) async {
    state = state.where((item) => item.name != name).toList();
  }
}

final shoppingProvider = StateNotifierProvider<ShoppingNotifier, List<ShoppingList>>((ref) {
  final dummyData = [
    ShoppingList(name: "My shopping list", shoppingListItems: []),
    ShoppingList(name: "Birthday party list", shoppingListItems: []),
  ];
  final notifier = ShoppingNotifier();
  notifier.addShoppingList(dummyData[0]);
  notifier.addShoppingList(dummyData[1]);
  return notifier;
});
