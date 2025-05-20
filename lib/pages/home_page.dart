import 'package:expense_tracker/bar%20graph/bar_graph.dart';
import 'package:expense_tracker/components/my_list_title.dart';
import 'package:expense_tracker/database/expense_database.dart';
import 'package:expense_tracker/helper/helper_functions.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // TODO text controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  // TODO futures to load graph data
  Future<Map<int, double>>? _monthlyTotalsFuture;

  @override
  void initState() {
    // TODO read db on initial startup
    Provider.of<ExpenseDatabase>(context, listen: false).readExpenses();

    // TODO load futures
    refreshGraphData();

    super.initState();
  }

  // TODO refresh graph data
  void refreshGraphData() {
    _monthlyTotalsFuture =
        Provider.of<ExpenseDatabase>(
          context,
          listen: false,
        ).calculateMonthlyTotals();
  }

  // TODO void open new expense box
  void openNewExpenseBox() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("New expense"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // TODO user input -> expense name
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(hintText: "Name"),
                ),

                // TODO user input -> expense amount
                TextField(
                  controller: amountController,
                  decoration: const InputDecoration(hintText: "Amount"),
                ),
              ],
            ),
            actions: [
              // TODO cancel button
              _cancelButton(),

              // TODO save button
              _createNewExpenseButton(),
            ],
          ),
    );
  }

  // TODO open edit box
  void openEditBox(Expense expense) {
    // TODO pre-fill existing values into textfields
    String existingName = expense.name;
    String existingAmount = expense.amount.toString();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Edit expense"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // TODO user input -> expense name
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(hintText: existingName),
                ),

                // TODO user input -> expense amount
                TextField(
                  controller: amountController,
                  decoration: InputDecoration(hintText: existingAmount),
                ),
              ],
            ),
            actions: [
              // TODO cancel button
              _cancelButton(),

              // TODO save button
              _editExpenseButton(expense),
            ],
          ),
    );
  }

  // TODO open delete box
  void openDeleteBox(Expense expense) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Delete expense?"),
            actions: [
              // TODO cancel button
              _cancelButton(),

              // TODO delete button
              _deleteExpenseButton(expense.id),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseDatabase>(
      builder: (context, value, child) {
        // TODO get dates
        int startMonth = value.getStartMonth();
        int startYear = value.getStartYear();
        int currentMonth = DateTime.now().month;
        int currentYear = DateTime.now().year;

        // TODO calculate the number of months since the first month
        int monthCount = calculateMonthCount(
          startYear,
          startMonth,
          currentYear,
          currentMonth,
        );

        // TODO only display the expenses for the current month

        // TODO return ui
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: openNewExpenseBox,
            child: const Icon(Icons.add),
          ),
          body: SafeArea(
            child: Column(
              children: [
                // TODO graph ui
                SizedBox(
                  height: 250,
                  child: FutureBuilder(
                    future: _monthlyTotalsFuture,
                    builder: (context, snapshot) {
                      // TODO data is loaded
                      if (snapshot.connectionState == ConnectionState.done) {
                        final monthlyTotals = snapshot.data ?? {};
            
                        // TODO create the list of monthly summary
                        List<double> monthlySummary = List.generate(
                          monthCount,
                          (index) => monthlyTotals[startMonth + index] ?? 0.0,
                        );
                        return MyBarGraph(
                          monthlySummary: monthlySummary,
                          startMonth: startMonth,
                        );
                      }
            
                      // TODO loading..
                      else {
                        return const Center(
                          child: Text("Loading.."),
                        );
                      }
                    },
                  ),
                ),
                // TODO expense list UI
                Expanded(
                  child: ListView.builder(
                    itemCount: value.allExpense.length,
                    itemBuilder: (context, index) {
                      // TODO get individual expense
                      Expense individualExpense = value.allExpense[index];
            
                      // TODO return list title UI
                      return MyListTitle(
                        title: individualExpense.name,
                        trailing: formatAmount(individualExpense.amount),
                        onEditPressed:
                            (context) => openEditBox(individualExpense),
                        onDeletePressed:
                            (context) => openDeleteBox(individualExpense),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // TODO cancel button
  Widget _cancelButton() {
    return MaterialButton(
      onPressed: () {
        // TODO pop box
        Navigator.pop(context);

        // TODO clear controllers
        nameController.clear();
        amountController.clear();
      },
      child: const Text('Cancel'),
    );
  }

  // TODO save button -> Create new expense
  Widget _createNewExpenseButton() {
    return MaterialButton(
      onPressed: () async {
        // TODO only save if there is something in the textfield to save
        if (nameController.text.isNotEmpty &&
            amountController.text.isNotEmpty) {
          // TODO pop box
          Navigator.pop(context);

          // TODO create new expense
          Expense newExpense = Expense(
            name: nameController.text,
            amount: convertStringToDouble(amountController.text),
            date: DateTime.now(),
          );

          // TODO save to db
          await context.read<ExpenseDatabase>().createNewExpense(newExpense);

          // TODO refresh graph
          refreshGraphData();

          // TODO clear controllers
          nameController.clear();
          amountController.clear();
        }
      },
      child: const Text('Save'),
    );
  }

  // TODO save button -> Edit existing expense
  Widget _editExpenseButton(Expense expense) {
    return MaterialButton(
      onPressed: () async {
        // TODO save as long as at least one textfield has been changed
        if (nameController.text.isNotEmpty ||
            amountController.text.isNotEmpty) {
          // TODO pop box
          Navigator.pop(context);

          // TODO create a new updated expense
          Expense updatedExpense = Expense(
            name:
                nameController.text.isNotEmpty
                    ? nameController.text
                    : expense.name,
            amount:
                amountController.text.isNotEmpty
                    ? convertStringToDouble(amountController.text)
                    : expense.amount,
            date: DateTime.now(),
          );

          // TODO old expense id
          int existingId = expense.id;

          // TODO save to db
          await context.read<ExpenseDatabase>().updateExpense(
            existingId,
            updatedExpense,
          );

          // TODO refresh graph
          refreshGraphData();
        }
      },
      child: const Text("Save"),
    );
  }

  // TODO delete button
  Widget _deleteExpenseButton(int id) {
    return MaterialButton(
      onPressed: () async {
        // TODO pop box
        Navigator.pop(context);

        // TODO delete expense from db
        await context.read<ExpenseDatabase>().deleteExpense(id);

        // TODO refresh graph
        refreshGraphData();
      },
      child: const Text("Delete"),
    );
  }
}
