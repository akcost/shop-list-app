import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_list_app/providers/shopping_provider.dart';
import 'package:shop_list_app/screens/add_list_screen.dart';
import 'package:shop_list_app/screens/shopping_list_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    final shoppingListsNew = ref.watch(shoppingProvider);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddListScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Shopping List"),
      ),
      body: ListView.builder(
        itemCount: shoppingListsNew.length,
        itemBuilder: (context, index) {
          final shoppingList = shoppingListsNew[index];
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
