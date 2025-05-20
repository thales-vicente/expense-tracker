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

  @override
  void initState() {
    Provider.of<ExpenseDatabase>(context, listen: false).readExpenses();
    super.initState();
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
      builder:
          (context, value, child) => Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: openNewExpenseBox,
              child: const Icon(Icons.add),
            ),
            body: ListView.builder(
              itemCount: value.allExpense.length,
              itemBuilder: (context, index) {
                // TODO get individual expense
                Expense individualExpense = value.allExpense[index];

                // TODO return list title UI
                return MyListTitle(
                  title: individualExpense.name,
                  trailing: formatAmount(individualExpense.amount),
                  onEditPressed: (context) => openEditBox(individualExpense),
                  onDeletePressed: (context) => openDeleteBox(individualExpense),
                );
              },
            ),
          ),
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
      },
      child: const Text("Delete"),
    );
  }
}
