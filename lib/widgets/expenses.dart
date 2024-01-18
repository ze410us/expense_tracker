import 'dart:collection';

import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/indicator.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final currencyFormatter = NumberFormat.simpleCurrency(locale: "en-US");

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
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

  late final Map<Category, double> expenseBuckets = HashMap();

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

  Color _getColorByCategory(Category cat) {
    return switch (cat) {
      Category.food => Colors.orangeAccent,
      Category.leisure => Colors.greenAccent,
      Category.travel => Colors.blueAccent,
      Category.work => Colors.blueGrey.shade200,
    };
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => AddExpense(_addExpense),
    );
  }

  @override
  Widget build(BuildContext context) {
    final noExpenseImageWidth = MediaQuery.of(context).size.width * 0.5;

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
      body: Center(
        child: Column(
          mainAxisAlignment: expenses.isNotEmpty
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (expenses.isNotEmpty) ...[
              SizedBox(
                height: MediaQuery.of(context).size.height * .2,
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: PieChart(
                        PieChartData(
                          centerSpaceRadius: 30,
                          sectionsSpace: 5,
                          sections: [
                            for (MapEntry<Category, double> eb
                                in expenseBuckets.entries)
                              PieChartSectionData(
                                color: _getColorByCategory(eb.key),
                                radius: 40,
                                value: eb.value,
                                titlePositionPercentageOffset: 1.6,
                                title: currencyFormatter.format(eb.value),
                                titleStyle: TextStyle(
                                  fontSize: 14,
                                  shadows: [
                                    Shadow(
                                      color: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .color!,
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          for (MapEntry<Category, double> eb
                              in expenseBuckets.entries) ...[
                            Indicator(
                              color: _getColorByCategory(eb.key),
                              text: eb.key.name,
                              isSquare: true,
                            ),
                            const SizedBox(
                              height: 4,
                            )
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: ExpensesList(
                  listOfExpenses: expenses,
                  onRemoveExpense: _removeExpense,
                ),
              )
            ] else ...[
              Image.asset(
                "assets/no_money.png",
                width: noExpenseImageWidth,
                height: noExpenseImageWidth,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "No expenses found",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
