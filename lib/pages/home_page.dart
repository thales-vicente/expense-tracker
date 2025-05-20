import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // TODO text controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  // TODO void open new expense box
  void openNewExpenseBox() {
    showDialog(
      context: context,
      builder:
          (context) =>
          AlertDialog(
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
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: openNewExpenseBox,
        child: const Icon(Icons.add),
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
      onPressed: () {
        // TODO only save if there is something in the textfield to save
        if (nameController.text.isNotEmpty &&
            amountController.text.isNotEmpty) {
          // TODO pop box
          Navigator.pop(context);

          // TODO create new expense
          Expense newExpense = Expense(
              name: nameController.text,
              amount: amountController.text,
              date: DateTime.now(),
          );
        }
      },
      child: const Text('Save'),
    );
  }
}
