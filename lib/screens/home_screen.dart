import 'package:flutter/material.dart';
import 'package:shop_list_app/models/shopping_item.dart';
import 'package:shop_list_app/models/shopping_list.dart';
import 'package:shop_list_app/models/shopping_list_item.dart';
import 'package:shop_list_app/screens/shopping_list_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ShoppingList> shoppingLists = [
    ShoppingList(
      name: "My shopping list",
      shoppingListItems: [
        ShoppingListItem(
            shoppingItem: const ShoppingItem(name: "Fish"), isChecked: false),
        ShoppingListItem(
            shoppingItem: const ShoppingItem(name: "Bread"), isChecked: false),
        ShoppingListItem(
            shoppingItem: const ShoppingItem(name: "Milk"), isChecked: false),
      ],
    ),
    ShoppingList(
      name: "Birthday party list",
      shoppingListItems: [
        ShoppingListItem(
            shoppingItem: const ShoppingItem(name: "Chips"), isChecked: false),
        ShoppingListItem(
            shoppingItem: const ShoppingItem(name: "Coca Cola"),
            isChecked: false),
        ShoppingListItem(
            shoppingItem: const ShoppingItem(name: "Dip"), isChecked: false),
        ShoppingListItem(
            shoppingItem: const ShoppingItem(name: "Cake"), isChecked: false),
      ],
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Shopping List"),
      ),
      body: ListView.builder(
        itemCount: shoppingLists.length,
        itemBuilder: (context, index) {
          final shoppingList = shoppingLists[index];
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShoppingListScreen(
                    shoppingList: shoppingList,
                  ),
                ),
              );
            },
            title: Text(shoppingList.name),
          );
        },
      ),
    );
  }
}
