import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_list_app/main.dart';
import 'package:shop_list_app/models/shopping_list.dart';
import 'package:shop_list_app/providers/shopping_provider.dart';
import 'package:shop_list_app/screens/add_item_screen.dart';
import 'package:shop_list_app/screens/add_list_screen.dart';
import 'package:shop_list_app/screens/home_screen.dart';
import 'package:shop_list_app/screens/shopping_list_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  testWidgets('should display shopping lists', (WidgetTester tester) async {
    // Create a mock ShoppingNotifier
    final mockShoppingNotifier = ShoppingNotifier();
    mockShoppingNotifier.state = {
      '1': ShoppingList(
        id: '1',
        name: 'Shopping List 1',
        shoppingListItemsMap: {},
      ),
      '2': ShoppingList(
        id: '2',
        name: 'Shopping List 2',
        shoppingListItemsMap: {},
      ),
    };

    // Create a ProviderContainer and override the ShoppingNotifier provider with the mockShoppingNotifier
    final container = ProviderContainer();
    container.read(shoppingProvider.notifier).state =
        mockShoppingNotifier.state;


    await tester.pumpWidget(
      ProviderScope(
        parent: container,
        child: const MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    // Verify that the shopping lists are displayed
    expect(find.text('Shopping List 1'), findsOneWidget);
    expect(find.text('Shopping List 2'), findsOneWidget);
  });

  testWidgets('should open add list screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.byType(AddListScreen), findsOneWidget);
  });

  testWidgets(
      'should open shopping list screen, tap on add item button and open add item screen',
      (WidgetTester tester) async {
    final mockShoppingNotifier = ShoppingNotifier();
    mockShoppingNotifier.state = {
      '1': ShoppingList(
        id: '1',
        name: 'Shopping List 1',
        shoppingListItemsMap: {},
      ),
    };

    // Create a ProviderContainer and override the ShoppingNotifier provider with the mockShoppingNotifier
    final container = ProviderContainer();
    container.read(shoppingProvider.notifier).state =
        mockShoppingNotifier.state;

    await tester.pumpWidget(
      ProviderScope(
        parent: container,
        child: MyApp(),
      ),
    );

    expect(find.text('Shopping List 1'), findsOneWidget);

    await tester.tap(find.text('Shopping List 1'));
    await tester.pumpAndSettle();

    expect(find.byType(ShoppingListScreen), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.byType(AddItemScreen), findsOneWidget);
  });
}
