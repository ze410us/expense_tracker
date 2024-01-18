import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expense_item.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatefulWidget {
  const ExpensesList({
    required this.listOfExpenses,
    required this.onRemoveExpense,
    super.key,
  });

  final List<Expense> listOfExpenses;
  final void Function(int) onRemoveExpense;

  @override
  State<ExpensesList> createState() => _ExpensesListState();
}

class _ExpensesListState extends State<ExpensesList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, index) {
        return Dismissible(
          direction: DismissDirection.endToStart,
          background: Container(
              margin: Theme.of(context).cardTheme.margin,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              alignment: Alignment.centerRight,
              color: Theme.of(context).colorScheme.error.withOpacity(0.6),
              child: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.onError,
              )),
          key: ValueKey<String>(widget.listOfExpenses[index].id),
          onDismissed: (DismissDirection direction) =>
              widget.onRemoveExpense(index),
          child: ExpenseItem(
            widget.listOfExpenses[index],
          ),
        );
      },
      itemCount: widget.listOfExpenses.length,
    );
  }
}
