import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_list_app/models/shopping_list.dart';
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

  int _getCheckedItemCount(ShoppingList shoppingList) {
    int count = 0;
    shoppingList.shoppingListItemsMap.values.forEach((item) {
      if (item.isChecked) {
        count++;
      }
    });
    return count;
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

    Widget content = const Center(
      child: Text("No lists added yet."),
    );

    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (shopLists.isNotEmpty) {
      content = ListView.builder(
        itemCount: shoppingLists.length,
        itemBuilder: (context, index) {
          final shoppingList = shopLists[index];

          int checkedItemCount = _getCheckedItemCount(shoppingList);
          return Dismissible(
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(''),
                  Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: Icon(
                      Icons.delete_forever,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            onDismissed: (direction) {
              ref
                  .read(shoppingProvider.notifier)
                  .removeShoppingList(shoppingList.id);
            },
            key: ValueKey(shoppingList.id),
            child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ShoppingListScreen(
                            shoppingListId: shoppingList.id,
                          ),
                    ),
                  );
                },
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        shoppingList.name,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Text(
                      "$checkedItemCount/${shoppingList.shoppingListItemsMap.length}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                subtitle: LinearProgressIndicator(
                  color: Colors.green,
                  backgroundColor: Colors.grey,
                  value: checkedItemCount /
                      (shoppingList.shoppingListItemsMap.isNotEmpty
                          ? shoppingList.shoppingListItemsMap.length.toDouble()
                          : 1),
                )),
          );
        },
      );
    }

    if (_error != null) {
      content = Center(
        child: Text(_error!),
      );
    }

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
          centerTitle: true,
          title: const Text("My Lists"),
        ),
        body: content);
  }
}
