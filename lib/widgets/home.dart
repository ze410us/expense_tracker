import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses/expense_add.dart';
import 'package:expense_tracker/widgets/expenses/no_expenses.dart';
import 'package:flutter/material.dart';

import 'expenses/chart/chart.dart';
import 'expenses/expenses_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final expenseBuckets = <Category, double>{};
  final List<Expense> expenses = [
    Expense(
      title: "Flutter course",
      amount: 19.99,
      date: DateTime.now().add(const Duration(days: -2, hours: 15)),
      category: Category.work,
    ),
    Expense(
      title: "Cinema",
      amount: 7.99,
      date: DateTime.now(),
      category: Category.leisure,
    )
  ];

  @override
  void initState() {
    super.initState();

    for (var expense in expenses) {
      _updateExpenseBucket(expense);
    }
  }

  void _updateExpenseBucket(Expense expense, {bool remove = false}) {
    if (remove) {
      expenseBuckets.update(
        expense.category,
        (value) => value - expense.amount,
      );
    } else {
      expenseBuckets.update(
        expense.category,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }
  }

  void _addExpense(Expense newExpense) {
    setState(() {
      expenses.add(newExpense);
      _updateExpenseBucket(newExpense);
    });
  }

  void _removeExpense(int index) {
    final expenseToDelete = expenses.elementAt(index);

    setState(() {
      expenses.removeAt(index);
      _updateExpenseBucket(expenseToDelete, remove: true);
    });

    _showPrompt(expenseToDelete, index);
  }

  void _showPrompt(Expense removedElement, int index) {
    final snackBar = SnackBar(
        content: Text("'${removedElement.title}' expense was deleted"),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            setState(() {
              expenses.insert(index, removedElement);
              _updateExpenseBucket(removedElement);
            });
          },
        ));

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => AddExpense(_addExpense),
    );
  }

  Widget getBody() {
    if (expenses.isEmpty) {
      return const Center(
        child: NoExpenses(),
      );
    } else {
      return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        ExpensesChart(expenseBuckets),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: ExpensesList(
            listOfExpenses: expenses,
            onRemoveExpense: _removeExpense,
          ),
        )
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense tracker"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _openAddExpenseOverlay,
          ),
        ],
      ),
      body: getBody(),
    );
  }
}
