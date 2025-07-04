import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackerop/money/components/my_list_tile.dart';
import 'package:trackerop/money/database/expenses_database.dart';
import 'package:trackerop/money/helper/helper_function.dart';
import 'package:trackerop/money/models/expenses.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
//text controller
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    Provider.of<expenses_database>(context, listen: false).readExpenses();

    super.initState();
  }

// open new expenses box
  void openNewExpensesBox() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text(" Expenses"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //user input -> expenses name
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(hintText: "Name"),
                  ),

//user input -> expenses amount
                  TextField(
                    controller: amountController,
                    decoration: const InputDecoration(hintText: "Amount "),
                  )
                ],
              ),
              actions: [
                //cancel button
                _cancelButton(),
                //save button
                _createNewExpensesButton(),
              ],
            ));
  }

  //open edit box
  void openEditBox(Expenses expenses) {
    //pre - fill existing value into textbox
    String existingName = expenses.name;
    String existingAmount = expenses.amount.toString();

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Edit Expenses"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //user input -> expenses name
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(hintText: existingName),
                  ),

//user input -> expenses amount
                  TextField(
                    controller: amountController,
                    decoration: InputDecoration(hintText: existingAmount),
                  )
                ],
              ),
              actions: [
                //cancel button
                _cancelButton(),
                //save button
                _editExpensesButton(expenses),
              ],
            ));
  }

  //open delete box
  void openDeleteBox(Expenses expenses) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Delete  Expenses"),
              actions: [
                //cancel button
                _cancelButton(),
                //save button
                _DeleteExpensesButton(expenses.id),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<expenses_database>(
      builder: (context, value, child) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: openNewExpensesBox,
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: value.allExpenses.length,
          itemBuilder: (context, index) {
            // get indiviual expenses
            Expenses indiviualExpenses = value.allExpenses[index];

            //return list title UI
            return MyListTile(
              title: indiviualExpenses.name,
              trailing: formateAmount(indiviualExpenses.amount),
              onEditPressed: (context) => openEditBox(indiviualExpenses),
              onDeletPressed: (context) => openDeleteBox(indiviualExpenses),
            );
          },
        ),
      ),
    );
  }

  //cancel button
  Widget _cancelButton() {
    return MaterialButton(
      onPressed: () {
//pop box
        Navigator.pop(context);

//clear controller
        nameController.clear();
        amountController.clear();
      },
      child: const Text('Cancel'),
    );
  }

//Save button -> create a new expenses
  Widget _createNewExpensesButton() {
    return MaterialButton(
      onPressed: () async {
        //only save if there is something in the textfield to save
        if (nameController.text.isNotEmpty &&
            amountController.text.isNotEmpty) {
          //POP BOX
          Navigator.pop(context);

          //create new expenses
          Expenses newExpenses = Expenses(
              name: nameController.text,
              amount: convertStringToDouble(amountController.text),
              date: DateTime.now());

          // save to db
          await context
              .read<expenses_database>()
              .createNewExpenses(newExpenses);

          //clear controller
          nameController.clear();
          amountController.clear();
        }
      },
      child: const Text("Save"),
    );
  }

//Save button -> Edit existing expenses
  Widget _editExpensesButton(Expenses expenses) {
    return MaterialButton(
      onPressed: () async {
        // save as long as at least one textfield has been changes
        if (nameController.text.isNotEmpty ||
            amountController.text.isNotEmpty) {
          //pop box
          Navigator.pop(context);

          //create a new updates box
          Expenses updatedExpenses = Expenses(
              name: nameController.text.isNotEmpty
                  ? nameController.text
                  : expenses.name,
              amount: amountController.text.isNotEmpty
                  ? convertStringToDouble(amountController.text)
                  : expenses.amount,
              date: DateTime.now());

// old expenses id
          int existingId = expenses.id;

          // save to db
          await context
              .read<expenses_database>()
              .updateExpenses(existingId, updatedExpenses);
        }
      },
      child: const Text('Save'),
    );
  }

//Delete button
  Widget _DeleteExpensesButton(int id) {
    return MaterialButton(
      onPressed: () async {
Navigator.pop(context); 

// delete expenses from db
await context.read<expenses_database>().deleteExpenses(id);
      },
      child:  const Text('Delete'),
    );
  }
}
