import 'package:flutter/material.dart';

class NoExpenses extends StatelessWidget {
  const NoExpenses({super.key});

  @override
  Widget build(BuildContext context) {
    final noExpenseImageWidth = MediaQuery.sizeOf(context).width * 0.5;

    return Column(
      children: [
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
    );
  }
}
