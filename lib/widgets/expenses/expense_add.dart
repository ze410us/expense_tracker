import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardHeight + 16),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: constraints.maxHeight -
                      30 -
                      (constraints.maxHeight > 600 ? keyboardHeight : 0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (constraints.maxWidth < 600)
                      ..._getColumnWidgets(context)
                    else
                      ..._getWideColumnWidgets(context, constraints)
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _getWideColumnWidgets(
    BuildContext context,
    BoxConstraints parentConstraints,
  ) {
    final maxRowHeight = parentConstraints.maxHeight / 4;
    return [
      ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxRowHeight),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              flex: 5,
              child: _getTitleTextWidget(),
            ),
            const SizedBox(
              width: 20,
            ),
            Flexible(
              flex: 3,
              child: _getAmountWidget(),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 30,
      ),
      ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxRowHeight),
        child: Row(
          children: [
            Flexible(
              flex: 5,
              child: _getDateWidget(),
            ),
            const SizedBox(
              width: 20,
            ),
            Flexible(
              flex: 3,
              child: _getCategoryWidget(),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 40,
      ),
      const Spacer(),
      _getActionButtonWidget(context),
    ];
  }

  List<Widget> _getColumnWidgets(BuildContext context) {
    return [
      _getTitleTextWidget(),
      IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _getAmountWidget(),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _getDateWidget(),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 40,
      ),
      _getCategoryWidget(),
      const Spacer(),
      _getActionButtonWidget(context),
    ];
  }

  Row _getActionButtonWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        )
      ],
    );
  }

  DropdownMenu<Category> _getCategoryWidget() {
    return DropdownMenu<Category>(
        initialSelection: Category.food,
        leadingIcon: Icon(selectedIcon),
        label: const Text("Category"),
        onSelected: changeCategory,
        dropdownMenuEntries: Category.values
            .map<DropdownMenuEntry<Category>>((Category cat) =>
                DropdownMenuEntry<Category>(
                    value: cat, label: cat.name, leadingIcon: Icon(cat.icon)))
            .toList());
  }

  TextFormField _getDateWidget() {
    return TextFormField(
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
    );
  }

  TextFormField _getAmountWidget() {
    return TextFormField(
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
    );
  }

  TextFormField _getTitleTextWidget() {
    return TextFormField(
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
    );
  }
}
