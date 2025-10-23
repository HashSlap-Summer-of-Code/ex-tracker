import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trackerop/money/models/expenses.dart';
import 'package:flutter/foundation.dart' show kDebugMode; // for build-mode detection

class expenses_database extends ChangeNotifier{
  static late Isar isar;
  List<Expenses> _allExpenses = [];

  // Whether the app is running against the test database
  static bool isTestMode = false;
  static String currentDbName = 'ex_tracker_prod';

/*
SETUP
*/
// initialize db
static  Future<void> initialize({bool? useTestDb}) async{
  final dir = await getApplicationDocumentsDirectory();

  // Determine test mode:
  // Priority: explicit parameter > --dart-define override > default by build mode
  // Robust parse: accept true/false/1/0/yes/no (case-insensitive)
  const String raw = String.fromEnvironment('USE_TEST_DB');
  final String envStr = raw.trim().toLowerCase();
  bool? envOverride;
  if (envStr == 'true' || envStr == '1' || envStr == 'yes') envOverride = true;
  if (envStr == 'false' || envStr == '0' || envStr == 'no') envOverride = false;

  final bool testMode = useTestDb ?? envOverride ?? kDebugMode;

  // Use distinct Isar names to keep data fully separated
  final String dbName = testMode ? 'ex_tracker_test' : 'ex_tracker_prod';

  isar = await Isar.open(
    [ExpensesSchema],
    directory: dir.path,
    name: dbName,
  );

  isTestMode = testMode;
  currentDbName = dbName;

  // Log selection so it can be verified even in release builds
  // These prints show up in device logs (e.g., logcat) and desktop terminal
  // Example: expenses_database: mode=TEST name=ex_tracker_test dir=/.../Documents
  // ignore: avoid_print
  print('expenses_database: mode=' + (isTestMode ? 'TEST' : 'PROD') +
      ' name=' + dbName + ' dir=' + dir.path);
}
/*
GETTERS
*/
List<Expenses> get allExpenses => _allExpenses;

/*
OPERATIONS
*/
// create  - add a new expenses
Future<void>createNewExpenses(Expenses NewExpenses) async{
//add to db
await isar.writeTxn(() => isar.expenses.put(NewExpenses));
//re - read from db 
 await readExpenses();



}
// read - expenses from db

Future <void> readExpenses() async{
 //fetch all existing expenses from db 
 List<Expenses> fetchedExpenses = await isar.expenses.where().findAll();

 // give to local exxpense list 
 _allExpenses.clear();
 _allExpenses.addAll(fetchedExpenses);

 // update UI 
 notifyListeners();
}
//update -edit an expenses 
Future<void>updateExpenses(int id ,Expenses updateExpenses ) async{
// make sure new expenses has same id as existing one 
updateExpenses.id=id;
//update in db
await isar.writeTxn(() => isar.expenses.put(updateExpenses));
// re-read from db 
await readExpenses();
}
//delete - an expenses 
Future<void>deleteExpenses(int id) async{
//delete from db
await isar.writeTxn(() => isar.expenses.delete(id));
//re-read from db
await readExpenses();
}
/*
HELPER
*/
}