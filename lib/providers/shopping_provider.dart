import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_list_app/models/shopping_item.dart';
import 'package:shop_list_app/models/shopping_list.dart';
import 'package:shop_list_app/models/shopping_list_item.dart';
import 'package:shop_list_app/config.dart';
import 'package:http/http.dart' as http;

class ShoppingNotifier extends StateNotifier<Map<String, ShoppingList>> {
  ShoppingNotifier() : super({});

  Future<void> getAllShoppingLists() async {
    final url = Uri.https(databaseUrl, 'shopping-lists.json');

    try {
      final response = await http.get(url);

      if (response.statusCode >= 400) {
        throw Exception("Failed to fetch data, please try again later.");
      }

      if (response.body == "null") {
        return;
      }

      final Map<String, dynamic> listData = jsonDecode(response.body);
      final Map<String, ShoppingList> shoppingListsMap = {};

      for (final item in listData.entries) {
        final shoppingList = ShoppingList(
          id: item.key,
          name: item.value["name"],
          shoppingListItemsMap: {},
        );

        if (item.value["items"] != null) {
          for (final entry in item.value["items"].entries) {
            final itemKey = entry.key;
            final itemValue = entry.value;

            final shoppingListItem = ShoppingListItem(
              id: itemKey,
              shoppingItem: ShoppingItem(name: itemValue["name"]),
              isChecked: itemValue["isChecked"],
            );

            shoppingList.shoppingListItemsMap[shoppingListItem.id] =
                shoppingListItem;
          }
        }

        shoppingListsMap[shoppingList.id] = shoppingList;
      }

      state = shoppingListsMap;
    } catch (err) {
      throw Exception(err);
    }
  }

  Future<void> saveShoppingListItem(String shoppingListId, String name) async {
    try {
      final url =
      Uri.https(databaseUrl, 'shopping-lists/$shoppingListId/items.json');
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

      final shoppingList = state[shoppingListId];

      final updatedList = ShoppingList(
        id: shoppingList!.id,
        name: shoppingList.name,
        shoppingListItemsMap: {
          ...shoppingList.shoppingListItemsMap,
          resData["name"]: ShoppingListItem(
            id: resData["name"],
            shoppingItem: ShoppingItem(name: name),
            isChecked: false,
          )
        },
      );

      state = {
        ...state,
        shoppingListId: updatedList,
      };
    } on Exception catch (e) {
      throw (Exception(e));
    }
  }

  Future<void> toggleCheckShoppingListItem(String shoppingListId,
      ShoppingListItem shoppingListItem) async {
    try {
      final url = Uri.https(databaseUrl,
          'shopping-lists/$shoppingListId/items/${shoppingListItem
              .id}.json');

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
        'name': shoppingListItem.shoppingItem.name,
        'isChecked': !shoppingListItem.isChecked,
        }),
      );

      if (response.statusCode >= 400) {
        throw Exception("Failed to fetch data please try again later.");
      }
      ShoppingList shoppingList = state[shoppingListId]!;
      shoppingList.shoppingListItemsMap[shoppingListItem.id]!.isChecked =
      !shoppingList.shoppingListItemsMap[shoppingListItem.id]!.isChecked;

      state = {
        ...state,
        shoppingListId: shoppingList,
      };
    } on Exception catch (e) {
      throw (Exception(e));
    }
  }


  Future<void> removeShoppingListItem(String shoppingListId,
      String shoppingListItemId) async {
    try {
      final url = Uri.https(databaseUrl,
          'shopping-lists/$shoppingListId/items/$shoppingListItemId.json');

      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        throw Exception("Failed to fetch data please try again later.");
      }
      ShoppingList shoppingList = state[shoppingListId]!;

      final updatedItemsMap =
      Map<String, ShoppingListItem>.from(shoppingList.shoppingListItemsMap);
      updatedItemsMap.remove(shoppingListItemId);
      final updatedList = ShoppingList(
        id: shoppingList.id,
        name: shoppingList.name,
        shoppingListItemsMap: updatedItemsMap,
      );

      state = {
        ...state,
        shoppingListId: updatedList,
      };
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
            'name': newListName,
            'items': [],
          },
        ),
      );
      if (response.statusCode >= 400) {
        throw Exception("Failed to fetch data please try again later.");
      }

      final Map<String, dynamic> resData = jsonDecode(response.body);

      state = {
        ...state,
        resData["name"]: ShoppingList(
          id: resData["name"],
          name: newListName,
          shoppingListItemsMap: {},
        ),
      };
    } on Exception catch (e) {
      throw (Exception(e));
    }

    await getAllShoppingLists();
  }

  Future<void> removeShoppingList(String shoppingListId) async {
    try {
      final url = Uri.https(databaseUrl, 'shopping-lists/$shoppingListId.json');

      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        throw Exception(
            "Failed to remove shopping list, please try again later.");
      }

      final updatedState = Map<String, ShoppingList>.from(state);
      updatedState.remove(shoppingListId);
      state = updatedState;
    } on Exception catch (e) {
      throw (Exception(e));
    }
  }

}

final shoppingProvider =
StateNotifierProvider<ShoppingNotifier, Map<String, ShoppingList>>((ref) {
  final notifier = ShoppingNotifier();
  return notifier;
});
