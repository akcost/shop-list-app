import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_list_app/models/shopping_item.dart';
import 'package:shop_list_app/models/shopping_list.dart';
import 'package:shop_list_app/models/shopping_list_item.dart';
import 'package:shop_list_app/config.dart';
import 'package:http/http.dart' as http;

class ShoppingNotifier extends StateNotifier<List<ShoppingList>> {
  ShoppingNotifier() : super([]);

  void addShoppingList(String newListName) {
    state = [
      ...state,
      ShoppingList(
        id: "",
        index: state.length,
        name: newListName,
        shoppingListItems: [],
      ),
    ];
  }

  void addShoppingListItem(int shoppingListId, ShoppingItem shoppingItem) {
    if (shoppingListId >= 0 && shoppingListId < state.length) {
      ShoppingListItem shoppingListItem =
          ShoppingListItem(shoppingItem: shoppingItem, isChecked: false);

      final shoppingList = state[shoppingListId];
      final updatedList = ShoppingList(
        id: shoppingList.id,
        index: shoppingListId,
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

  Future<void> getAllShoppingLists() async {
    final url = Uri.https(databaseUrl, 'shopping-lists.json');

    try {
      final response = await http.get(url);

      if (response.statusCode >= 400) {
        throw Exception("Failed to fetch data please try again later.");
      }

      if (response.body == "null") {
        return;
      }

      final Map<String, dynamic> listData = jsonDecode(response.body);
      final List<ShoppingList> shoppingLists = [];

      for (final item in listData.entries) {

        ShoppingList shoppingList = ShoppingList(
            id: item.key,
            index: item.value["index"],
            name: item.value["name"],
            shoppingListItems: []);

        if (item.value["items"] != null) {
          for (final shopItem in item.value["items"]) {
            ShoppingListItem shoppingListItem = ShoppingListItem(
              shoppingItem: ShoppingItem(
                name: shopItem["name"],
              ),
              isChecked: shopItem["isChecked"],
            );
            shopItem["name"];
            shopItem["isChecked"];
            shoppingList.shoppingListItems.add(shoppingListItem);
          }
        }
        shoppingLists.add(shoppingList);
      }

      state = shoppingLists;
    } catch (err) {
      throw Exception(err);
    }
  }

  Future<void> saveShoppingListItem(String shoppingListId, String name, int shoppingListIndex) async {
    try {
      final url = Uri.https(
          databaseUrl,
          'shopping-lists/$shoppingListId/items.json');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            'name': name,
            'isChecked': false,
          },
        ),
      );
      if (response.statusCode >= 400) {
        throw Exception("Failed to fetch data please try again later.");
      }

      final Map<String, dynamic> resData = jsonDecode(response.body);

      final shoppingList = state[shoppingListIndex];
      final updatedList = ShoppingList(
        id: shoppingList.id,
        index: shoppingListIndex,
        name: shoppingList.name,
        shoppingListItems: [
          ...shoppingList.shoppingListItems,
          ShoppingListItem(shoppingItem: ShoppingItem(name: name), isChecked: false),
        ],
      );

      state = [
        ...state.sublist(0, shoppingListIndex),
        updatedList,
        ...state.sublist(shoppingListIndex + 1),
      ];
    } on Exception catch (e) {
      throw (Exception(e));
    }
  }

  Future<void> saveShoppingList(String newListName) async {
    try {
      final url = Uri.https(databaseUrl, 'shopping-lists.json');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            'index': state.length,
            'name': newListName,
            'items': [],
          },
        ),
      );
      if (response.statusCode >= 400) {
        throw Exception("Failed to fetch data please try again later.");
      }

      final Map<String, dynamic> resData = jsonDecode(response.body);

      state = [
        ...state,
        ShoppingList(
          id: resData["name"],
          index: state.length,
          name: newListName,
          shoppingListItems: [],
        ),
      ];
    } on Exception catch (e) {
      throw (Exception(e));
    }

    await getAllShoppingLists();
  }

  void removeShoppingList(int shoppingListId) {
    state = state.where((item) => item.index != shoppingListId).toList();
  }

  void removeShoppingListItem(int shoppingListIndex, int itemIndex) {
    if (shoppingListIndex >= 0 && shoppingListIndex < state.length) {
      final shoppingList = state[shoppingListIndex];
      final updatedItems =
          List<ShoppingListItem>.from(shoppingList.shoppingListItems);
      if (itemIndex >= 0 && itemIndex < updatedItems.length) {
        updatedItems.removeAt(itemIndex);
        final updatedList = ShoppingList(
          id: shoppingList.id,
          index: shoppingList.index,
          name: shoppingList.name,
          shoppingListItems: updatedItems,
        );
        state = [
          ...state.sublist(0, shoppingListIndex),
          updatedList,
          ...state.sublist(shoppingListIndex + 1),
        ];
      }
    }
  }
}

final shoppingProvider =
    StateNotifierProvider<ShoppingNotifier, List<ShoppingList>>((ref) {
  final notifier = ShoppingNotifier();
  // notifier.addShoppingList("My shopping list");
  // notifier.addShoppingList("Birthday party list");
  return notifier;
});
