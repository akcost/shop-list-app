import 'package:flutter/material.dart';
import 'package:shop_list_app/models/grocery_item.dart';
import 'package:shop_list_app/models/grocery_list_item.dart';

import 'add_item_screen.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final List<GroceryListItem> groceryListItems = [
    GroceryListItem(
        groceryItem: const GroceryItem(name: "Fish"), isChecked: false),
    GroceryListItem(
        groceryItem: const GroceryItem(name: "Bread"), isChecked: false),
    GroceryListItem(
        groceryItem: const GroceryItem(name: "Milk"), isChecked: false),
  ];

  Future<void> _navigateToAddItemScreen() async {
    final newItem = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const AddItem()),
    );

    if (newItem != null) {
      setState(() {
        groceryListItems.add(
          GroceryListItem(
            groceryItem: GroceryItem(name: newItem),
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
        title: const Text("Shopping List"),
      ),
      body: ListView.builder(
        itemCount: groceryListItems.length,
        itemBuilder: (context, index) {
          final groceryListItem = groceryListItems[index];
          return ListTile(
            onTap: () {
              setState(() {
                groceryListItem.isChecked = !groceryListItem.isChecked;
              });
            },
            leading: Checkbox(
              value: groceryListItem.isChecked,
              onChanged: (value) {
                setState(() {
                  groceryListItem.isChecked = value ?? false;
                });
              },
            ),
            title: Text(groceryListItem.groceryItem.name),
          );
        },
      ),
    );
  }
}
