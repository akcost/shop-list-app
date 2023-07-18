
# Shopping List App
Simple shopping list app to help you track your shopping
## An app where you can

* Create multiple shopping lists
* Add items to a shopping list
* Check items on the shopping list
* See the progress of your shopping list
* Remove items from your shopping list
* Delete a shopping list

## Running the app

Use `flutter run` command to run the app from commandline.

## Running tests

Tests are located in the `test` folder.

Run `flutter test test/ui_tests.dart` for UI related tests.  
Run `flutter test test/unit_tests.dart` for unit tests.

## Structure

There are 3 main components in this app:

1. `models`
2. `providers`
3. `screens`

The `models` folder contains essential models that represent shopping lists and items.

The `providers` folder contains a ShoppingNotifier class that acts as a communication layer between  the  application and the database, providing methods to fetch, save, update, and remove shopping lists  and items.

The `screens` folder contains the different screens of the application, including the `HomeScreen` , `ShoppingListScreen`, `AddItemScreen`, and `AddListScreen`. These screens are responsible for  
rendering the UI elements and interacting with the user, utilizing the `providers` and `models` to  
manage data and perform actions such as fetching, saving, and removing shopping lists and items.

## Database
The app uses Firebase Realtime database. The database configuration can be found inside `config.dart`.