import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_list_app/models/shopping_item.dart';
import 'package:shop_list_app/models/shopping_list.dart';
import 'package:shop_list_app/models/shopping_list_item.dart';

class ShoppingNotifier extends StateNotifier<List<ShoppingList>> {
  ShoppingNotifier() : super([]);

  void addShoppingList(String newListName) {
    state = [
      ...state,
      ShoppingList(
        id: state.length,
        name: newListName,
        shoppingListItems: [],
      )
    ];
  }

  void addShoppingListItem(int shoppingListId, ShoppingItem shoppingItem) {
    if (shoppingListId >= 0 && shoppingListId < state.length) {
      ShoppingListItem shoppingListItem =
      ShoppingListItem(shoppingItem: shoppingItem, isChecked: false);

      final shoppingList = state[shoppingListId];
      final updatedList = ShoppingList(
        id: shoppingListId,
        name: shoppingList.name,
        shoppingListItems: [
          ...shoppingList.shoppingListItems,
          shoppingListItem,
        ],
      );

      state = [
        ...state.sublist(0, shoppingListId),
        updatedList,
        ...state.sublist(shoppingListId + 1),
      ];
    }

  }

  void removeShoppingList(int shoppingListId) async {
    state = state.where((item) => item.id != shoppingListId).toList();
  }
}

final shoppingProvider =
StateNotifierProvider<ShoppingNotifier, List<ShoppingList>>((ref) {
  final notifier = ShoppingNotifier();
  notifier.addShoppingList("My shopping list");
  notifier.addShoppingList("Birthday party list");
  return notifier;
});
