import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_list_app/providers/shopping_provider.dart';

class AddListScreen extends ConsumerStatefulWidget {
  const AddListScreen({super.key});

  @override
  ConsumerState<AddListScreen> createState() => _AddListScreenState();
}

class _AddListScreenState extends ConsumerState<AddListScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  void _addList(String newListName) {
    if (newListName.isNotEmpty) {
      ref.read(shoppingProvider.notifier).saveShoppingList(newListName);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New List"),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextField(
              focusNode: _focusNode,
              autocorrect: false,
              controller: _textEditingController,
              decoration: const InputDecoration(
                labelText: "List Name",
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
                _addList(_textEditingController.text.trim());
              },
              child: const Text("Create"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
