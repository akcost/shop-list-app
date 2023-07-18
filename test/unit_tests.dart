import 'package:flutter_test/flutter_test.dart';
import 'package:shop_list_app/config.dart';
import 'package:shop_list_app/models/shopping_list.dart';
import 'package:shop_list_app/models/shopping_list_item.dart';
import 'package:shop_list_app/providers/shopping_provider.dart';
import 'package:http/http.dart' as http;


void main() {
  group('ShoppingNotifier', () {
    test('should add a new shopping list', () async {
      // Delete all lists from the database
      final url = Uri.https(databaseUrl, 'shopping-lists.json');

      await http.delete(url);

      // Arrange

      final shoppingNotifier = ShoppingNotifier();
      const newListName = 'Test Shopping List';

      // Act
      await shoppingNotifier.saveShoppingList(newListName);

      // Assert that list was added
      final state = shoppingNotifier.state;
      expect(state.length, 1);

      String shoppingListId = state.entries.first.value.id;
      ShoppingList expectedShoppingList = ShoppingList(
        id: shoppingListId,
        name: newListName,
        shoppingListItemsMap: {},
      );

      // Assert that correct shopping list details were added
      expect(state[shoppingListId]!.name, expectedShoppingList.name);
      expect(state[shoppingListId]!.shoppingListItemsMap, expectedShoppingList.shoppingListItemsMap);
    });
  });

  test('should remove a shopping list', () async {
    // Delete all lists from the database
    final url = Uri.https(databaseUrl, 'shopping-lists.json');

    await http.delete(url);

    // Arrange

    final shoppingNotifier = ShoppingNotifier();
    const newListName = 'Test Shopping List';

    // Act
    await shoppingNotifier.saveShoppingList(newListName);

    // Assert
    var state = shoppingNotifier.state;
    String shoppingListId = state.entries.first.value.id;
    ShoppingList expectedShoppingList = ShoppingList(
      id: shoppingListId,
      name: newListName,
      shoppingListItemsMap: {},
    );

    // Assert that the shopping list was added
    expect(state.length, 1);
    expect(state[shoppingListId]!.name, expectedShoppingList.name);
    expect(state[shoppingListId]!.shoppingListItemsMap, expectedShoppingList.shoppingListItemsMap);

    // Act
    await shoppingNotifier.removeShoppingList(shoppingListId);

    // Assert that the shopping list was removed
    state = shoppingNotifier.state;
    expect(state.length, 0);
  });

  test('should add a new item to a shopping list', () async {
    // Delete all lists from the database
    final url = Uri.https(databaseUrl, 'shopping-lists.json');

    await http.delete(url);

    // Arrange

    final shoppingNotifier = ShoppingNotifier();
    const newListName = 'Test Shopping List';

    // Act
    await shoppingNotifier.saveShoppingList(newListName);

    // Assert
    var state = shoppingNotifier.state;
    String shoppingListId = state.entries.first.value.id;
    ShoppingList expectedShoppingList = ShoppingList(
      id: shoppingListId,
      name: newListName,
      shoppingListItemsMap: {},
    );

    // Assert that the shopping list was added

    expect(state.length, 1);
    expect(state[shoppingListId]!.name, expectedShoppingList.name);
    expect(state[shoppingListId]!.shoppingListItemsMap, expectedShoppingList.shoppingListItemsMap);

    // Act
    await shoppingNotifier.saveShoppingListItem(shoppingListId, "Bread");

    state = shoppingNotifier.state;
    String expectedName = state[shoppingListId]!.shoppingListItemsMap.entries.first.value.shoppingItem.name;
    // Assert that an item with correct name was added to the shopping list
    expect(state[shoppingListId]!.shoppingListItemsMap.length, 1);
    expect(expectedName, "Bread");
  });

  test('should remove an item from a shopping list', () async {
    // Delete all lists from the database
    final url = Uri.https(databaseUrl, 'shopping-lists.json');

    await http.delete(url);

    // Arrange

    final shoppingNotifier = ShoppingNotifier();
    const newListName = 'Test Shopping List';

    // Act
    await shoppingNotifier.saveShoppingList(newListName);

    // Assert
    var state = shoppingNotifier.state;
    String shoppingListId = state.entries.first.value.id;
    ShoppingList expectedShoppingList = ShoppingList(
      id: shoppingListId,
      name: newListName,
      shoppingListItemsMap: {},
    );

    // Assert that the shopping list was added

    expect(state.length, 1);
    expect(state[shoppingListId]!.name, expectedShoppingList.name);
    expect(state[shoppingListId]!.shoppingListItemsMap, expectedShoppingList.shoppingListItemsMap);

    await shoppingNotifier.saveShoppingListItem(shoppingListId, "Bread");

    // Assert that an item was added to the shopping list
    state = shoppingNotifier.state;
    expect(state[shoppingListId]!.shoppingListItemsMap.length, 1);

    // Remove the item from the shopping list
    String shoppingListItemId = state[shoppingListId]!.shoppingListItemsMap.entries.first.value.id;
    await shoppingNotifier.removeShoppingListItem(shoppingListId, shoppingListItemId);

    // Assert that the item was removed
    state = shoppingNotifier.state;
    expect(state[shoppingListId]!.shoppingListItemsMap.length, 0);
  });

  test('should check an item on a shopping list', () async {
    // Delete all lists from the database
    final url = Uri.https(databaseUrl, 'shopping-lists.json');

    await http.delete(url);

    // Arrange

    final shoppingNotifier = ShoppingNotifier();
    const newListName = 'Test Shopping List';

    // Act
    await shoppingNotifier.saveShoppingList(newListName);

    // Assert
    var state = shoppingNotifier.state;
    String shoppingListId = state.entries.first.value.id;
    ShoppingList expectedShoppingList = ShoppingList(
      id: shoppingListId,
      name: newListName,
      shoppingListItemsMap: {},
    );

    // Assert that the shopping list was added
    expect(state.length, 1);
    expect(state[shoppingListId]!.name, expectedShoppingList.name);
    expect(state[shoppingListId]!.shoppingListItemsMap, expectedShoppingList.shoppingListItemsMap);

    await shoppingNotifier.saveShoppingListItem(shoppingListId, "Milk");

    state = shoppingNotifier.state;
    expect(state[shoppingListId]!.shoppingListItemsMap.length, 1);
    ShoppingListItem shoppingListItem = state[shoppingListId]!.shoppingListItemsMap.entries.first.value;

    // Check the items checkbox in the shopping list
    await shoppingNotifier.toggleCheckShoppingListItem(shoppingListId, shoppingListItem);
    state = shoppingNotifier.state;

    // Assert that the checkbox was checked
    expect(state[shoppingListId]!.shoppingListItemsMap[shoppingListItem.id]!.isChecked, true);
  });
}
