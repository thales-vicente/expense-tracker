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

  /*

  H E L P E R

   */

  // TODO calculate total expenses for each month
  Future<Map<int, double>> calculateMonthlyTotals() async {
    // TODO ensure the expenses are read from the db
    await readExpenses();

    // TODO create a map to keep track of total expenses per month
    Map<int, double> monthlyTotals = {};

    // TODO iterate over all expenses
    for (var expense in _allExpenses){
      // TODO extract the month from the date of the expense
      int month = expense.date.month;

      // TODO if the month is not yet in the map, initialize to 0
      if (!monthlyTotals.containsKey(month)) {
        monthlyTotals[month] = 0;
      }

      // TODO add the expense amount to the total for the month
      monthlyTotals[month] = monthlyTotals[month] ! + expense.amount;
    }

    return monthlyTotals;
  }

  // TODO get start month
  int getStartMonth() {
    if(_allExpenses.isEmpty){
      return DateTime.now().month; // default to current month is no expenses are recorded
    }

    // TODO sort expenses by date to find the earliest
    _allExpenses.sort((a, b) => a.date.compareTo(b.date),
    );
    return _allExpenses.first.date.month;
  }

  // TODO get start year
  int getStartYear() {
    if(_allExpenses.isEmpty){
      return DateTime.now().year; // default to current year is no expenses are recorded
    }

    // TODO sort expenses by date to find the earliest
    _allExpenses.sort((a, b) => a.date.compareTo(b.date),
    );
    return _allExpenses.first.date.year;
  }
}