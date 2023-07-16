import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_list_app/models/shopping_item.dart';
import 'package:shop_list_app/providers/shopping_provider.dart';


class AddItemScreen extends ConsumerStatefulWidget {
  const AddItemScreen({super.key, required this.shoppingListId});

  final int shoppingListId;

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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                labelText: "Item Name",
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final newShoppingItemName = _textEditingController.text.trim();
                if (newShoppingItemName.isNotEmpty) {
                  ref.read(shoppingProvider.notifier).addShoppingListItem(
                    widget.shoppingListId,
                    ShoppingItem(name: newShoppingItemName)
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
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
