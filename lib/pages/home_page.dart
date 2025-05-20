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
}
