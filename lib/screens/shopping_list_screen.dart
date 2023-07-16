import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_list_app/providers/shopping_provider.dart';

import 'add_item_screen.dart';

class ShoppingListScreen extends ConsumerStatefulWidget {
  const ShoppingListScreen({super.key, required this.shoppingListId});

  final int shoppingListId;

  @override
  ConsumerState<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends ConsumerState<ShoppingListScreen> {
  @override
  Widget build(BuildContext context) {
    final shoppingList = ref
        .watch(shoppingProvider)
        .firstWhere((list) => list.id == widget.shoppingListId);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddItemScreen(
                shoppingListId: widget.shoppingListId,
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
        itemCount: shoppingList.shoppingListItems.length,
        itemBuilder: (context, index) {
          final shoppingListItem = shoppingList.shoppingListItems[index];
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
            title: Text(shoppingListItem.shoppingItem.name),
          );
        },
      ),
    );
  }
}
