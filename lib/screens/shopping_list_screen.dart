import 'package:flutter/material.dart';
import 'package:shop_list_app/models/shopping_item.dart';
import 'package:shop_list_app/models/shopping_list.dart';
import 'package:shop_list_app/models/shopping_list_item.dart';

import 'add_item_screen.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key, required this.shoppingList});

  final ShoppingList shoppingList;

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {

  Future<void> _navigateToAddItemScreen() async {
    final newItem = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const AddItemScreen()),
    );

    if (newItem != null) {
      setState(() {
        widget.shoppingList.shoppingListItems.add(
          ShoppingListItem(
            shoppingItem: ShoppingItem(name: newItem),
            isChecked: false,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddItemScreen,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text(widget.shoppingList.name),
      ),
      body: ListView.builder(
        itemCount: widget.shoppingList.shoppingListItems.length,
        itemBuilder: (context, index) {
          final shoppingListItem = widget.shoppingList.shoppingListItems[index];
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
