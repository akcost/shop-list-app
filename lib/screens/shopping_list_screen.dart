import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_list_app/providers/shopping_provider.dart';

import 'add_item_screen.dart';

class ShoppingListScreen extends ConsumerStatefulWidget {
  const ShoppingListScreen({super.key, required this.shoppingListId});

  final String shoppingListId;

  @override
  ConsumerState<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends ConsumerState<ShoppingListScreen> {
  @override
  Widget build(BuildContext context) {

    final shoppingList = ref.watch(shoppingProvider)[widget.shoppingListId];
    final shopList = shoppingList!.shoppingListItemsMap.values.toList();

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddItemScreen(
                shoppingListId: shoppingList.id,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text(shoppingList.name),
      ),
      body: ListView.builder(
        itemCount: shoppingList.shoppingListItemsMap.length,
        itemBuilder: (context, index) {
          final shoppingListItem = shopList[index];
          return ListTile(
            onTap: () {
              setState(() {
                shoppingListItem.isChecked = !shoppingListItem.isChecked;
              });
            },
            leading: Checkbox(
              value: shoppingListItem.isChecked,
              onChanged: (value) {
                setState(() {
                  shoppingListItem.isChecked = value ?? false;
                });
              },
            ),
            trailing: IconButton(
                onPressed: () {
                  ref
                      .read(shoppingProvider.notifier)
                      .removeShoppingListItem(shoppingList.id, shoppingListItem.id);
                },
                icon: const Icon(Icons.delete_forever)),
            title: Text(shoppingListItem.shoppingItem.name),
          );
        },
      ),
    );
  }
}
