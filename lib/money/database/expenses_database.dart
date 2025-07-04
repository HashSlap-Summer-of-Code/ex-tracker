import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trackerop/money/models/expenses.dart';

class expenses_database extends ChangeNotifier{
  static late Isar isar;
  List<Expenses> _allExpenses = [];

/*
SETUP
*/
// initialize db
static  Future<void> initialize() async{
  final dir = await getApplicationDocumentsDirectory();
  isar = await Isar.open([ExpensesSchema], directory: dir.path);
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