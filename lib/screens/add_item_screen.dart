import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_list_app/providers/shopping_provider.dart';

class AddItemScreen extends ConsumerStatefulWidget {
  const AddItemScreen({super.key, required this.shoppingListId});

  final String shoppingListId;

  @override
  ConsumerState<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends ConsumerState<AddItemScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Item"),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16,16,16,32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextField(
              autocorrect: false,
              controller: _textEditingController,
              decoration: const InputDecoration(
                labelText: "Name",
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                padding: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                  top: 10,
                  bottom: 10,
                ),
              ),
              onPressed: () {
                final newShoppingItemName = _textEditingController.text.trim();
                if (newShoppingItemName.isNotEmpty) {
                  ref.read(shoppingProvider.notifier).saveShoppingListItem(
                      widget.shoppingListId, newShoppingItemName);
                  Navigator.pop(context);
                }
              },
              child: const Text(
                "Add",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
