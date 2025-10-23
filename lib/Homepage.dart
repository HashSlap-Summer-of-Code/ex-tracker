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
  // New: description controller
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    Provider.of<expenses_database>(context, listen: false).readExpenses();

    super.initState();
  }

// open new expenses box
  void openNewExpensesBox() {
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                title: const Text(" Expenses"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //user input -> expenses name
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(hintText: "Name"),
                      onChanged: (value) => setState(() {}),
                    ),

//user input -> expenses amount
                    TextField(
                      controller: amountController,
                      decoration: const InputDecoration(hintText: "Amount "),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => setState(() {}),
                    ),
                    //user input -> description (required)
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(hintText: "Description"),
                      onChanged: (value) => setState(() {}),
                    )
                  ],
                ),
                actions: [
                  //cancel button
                  _cancelButton(),
                  //save button
                  _createNewExpensesButton(),
                ],
              ),
            ));
  }

  //open edit box
  void openEditBox(Expenses expenses) {
    //pre - fill existing value into textbox
    String existingName = expenses.name;
    String existingAmount = expenses.amount.toString();

    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                title: const Text("Edit Expenses"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //user input -> expenses name
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(hintText: "Description"),
                      onChanged: (value) => setState(() {}),
                    ),

//user input -> expenses amount
                    TextField(
                      controller: amountController,
                      decoration: InputDecoration(hintText: existingAmount),
                      onChanged: (value) => setState(() {}),
                    ),
                    //user input -> description (required for new, optional for edit)
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(hintText: "Description"),
                      onChanged: (value) => setState(() {}),
                    )
                  ],
                ),
                actions: [
                  //cancel button
                  _cancelButton(),
                  //save button
                  _editExpensesButton(expenses),
                ],
              ),
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
    bool isValid = nameController.text.isNotEmpty &&
        amountController.text.isNotEmpty &&
        double.tryParse(amountController.text) != null &&
        descriptionController.text.isNotEmpty;
    return MaterialButton(
      onPressed: isValid
          ? () async {
              //POP BOX
              Navigator.pop(context);

              //create new expenses
              Expenses newExpenses = Expenses(
                  name: nameController.text,
                  amount: convertStringToDouble(amountController.text),
                  date: DateTime.now(),
                  description: descriptionController.text);

              // save to db
              await context
                  .read<expenses_database>()
                  .createNewExpenses(newExpenses);

              //clear controller
              nameController.clear();
              amountController.clear();
              descriptionController.clear();
            }
          : null,
      child: const Text("Save"),
    );
  }

//Save button -> Edit existing expenses
  Widget _editExpensesButton(Expenses expenses) {
    bool nameValid = nameController.text.isNotEmpty;
    bool amountValid = amountController.text.isEmpty || double.tryParse(amountController.text) != null;
    bool isValid = nameValid && amountValid;
    return MaterialButton(
      onPressed: isValid
          ? () async {
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
                  date: DateTime.now(),
                  description: descriptionController.text.isNotEmpty
                      ? descriptionController.text
                      : expenses.description);

// old expenses id
              int existingId = expenses.id;

              // save to db
              await context
                  .read<expenses_database>()
                  .updateExpenses(existingId, updatedExpenses);
            }
          : null,
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
