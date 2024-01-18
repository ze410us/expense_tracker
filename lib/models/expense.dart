import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();
final formatter = DateFormat.yMd();

class Expense {
  final String id = uuid.v4();
  String title;
  double amount;
  DateTime date;
  Category category;

  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });

  String get getFormattedDate => formatter.format(date);
}

enum Category {
  food(icon: Icons.lunch_dining),
  leisure(icon: Icons.movie),
  travel(icon: Icons.flight_takeoff),
  work(icon: Icons.work);

  const Category({required this.icon});

  final IconData icon;
}

class ExpenseBucket {
  final Category category;
  final List<Expense> expenses;

  ExpenseBucket.forCategory(List<Expense> expenses, this.category)
      : expenses = expenses
            .where((Expense expense) => expense.category == category)
            .toList();
  ExpenseBucket({required this.category, required this.expenses});

  get totalExpenses => expenses.isEmpty
      ? 0.0
      : expenses
          .map((Expense expense) => expense.amount)
          .reduce((value, element) => value + element);
}
