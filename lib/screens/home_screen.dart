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
  var _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    try {
      await ref.read(shoppingProvider.notifier).getAllShoppingLists();
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      setState(() {
        _isLoading = false;
        _error = "Something went wrong! Please try again later.";
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final shoppingLists = ref.watch(shoppingProvider);
    final shopLists = shoppingLists.values.toList();


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
        itemCount: shoppingLists.length,
        itemBuilder: (context, index) {
          final shoppingList = shopLists[index];
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShoppingListScreen(
                    shoppingListId: shoppingList.id,
                  ),
                ),
              );
            },
            trailing: IconButton(onPressed: () {
              ref.read(shoppingProvider.notifier).removeShoppingList(shoppingList.id);
            }, icon: const Icon(Icons.delete_forever)),
            title: Text(shoppingList.name),
          );
        },
      ),
    );
  }
}
