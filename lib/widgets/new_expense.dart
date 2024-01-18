import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class AddExpense extends StatefulWidget {
  final void Function(Expense newExpense) updateCallback;

  const AddExpense(this.updateCallback, {super.key});

  @override
  _AddExpenseState createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final Expense newExpense = Expense(
      title: "", amount: 0, date: DateTime.now(), category: Category.food);
  IconData selectedIcon = Category.food.icon;

  void changeCategory(Category? selectedCategory) {
    if (selectedCategory != null) {
      setState(() {
        selectedIcon = selectedCategory.icon;
        newExpense.category = selectedCategory;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void openCalendar() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2025),
    ).then((value) {
      if (value != null) {
        newExpense.date = value;
        _dateController.text = newExpense.getFormattedDate;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            TextFormField(
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Please enter the title";
                }

                return null;
              },
              controller: _titleController,
              maxLength: 30,
              decoration: const InputDecoration(
                label: Text(
                  "Title",
                ),
              ),
            ),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter the amount";
                        }

                        return null;
                      },
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        prefixText: "\$",
                        label: Text("Amount"),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter the date";
                        }

                        return null;
                      },
                      controller: _dateController,
                      onTap: () => openCalendar(),
                      keyboardType: TextInputType.none,
                      decoration: const InputDecoration(
                        label: Text("Date"),
                        prefixIcon: Icon(Icons.calendar_month),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                DropdownMenu<Category>(
                    initialSelection: Category.food,
                    leadingIcon: Icon(selectedIcon),
                    label: const Text("Category"),
                    onSelected: changeCategory,
                    dropdownMenuEntries: Category.values
                        .map<DropdownMenuEntry<Category>>((Category cat) =>
                            DropdownMenuEntry<Category>(
                                value: cat,
                                label: cat.name,
                                leadingIcon: Icon(cat.icon)))
                        .toList()),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      newExpense.title = _titleController.text;
                      newExpense.amount = double.parse(_amountController.text);
                      widget.updateCallback(newExpense);

                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("Save changes"),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel"),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}
