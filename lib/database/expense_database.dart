import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class ExpenseDatabase extends ChangeNotifier{
  static late Isar isar;
  List<Expense> _allExpenses = [];

  /*

  S E T U P

   */

  // TODO initialize db
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([ExpenseSchema], directory: dir.path);
  }

  /*

  G E T T E R S

   */

  List<Expense> get allExpense => _allExpenses;

  /*

  O P E R A T I O N S

   */

  // TODO Create - add a new expense
  Future<void> createNewExpense(Expense newExpense) async {
    // TODO add to db
    await isar.writeTxn(() => isar.expenses.put(newExpense));

    // TODO re-read from db
    await readExpenses();
  }

  // TODO Read - expenses from db
  Future<void> readExpenses() async {
    // TODO fetch all existing expenses from db
    List<Expense> fetchedExpenses = await isar.expenses.where().findAll();

    // TODO give to local expense list
    _allExpenses.clear();
    _allExpenses.addAll(fetchedExpenses);

    // TODO update UI
    notifyListeners();
  }

  // TODO Update - edit an expense in db
  Future<void> updateExpense(int id, Expense updateExpense) async {
    // TODO make sure new expense has same id as exisiting one
    updateExpense.id = id;

    // TODO update in db
    await isar.writeTxn(() => isar.expenses.put(updateExpense));

    // TODO re-read from db
    await readExpenses();
  }

  // TODO Delete - an expense
  Future<void> deleteExpense(int id) async {
    // TODO delete from db
    await isar.writeTxn(() => isar.expenses.delete(id));

    // TODO re-read from db
    await readExpenses();
  }
}