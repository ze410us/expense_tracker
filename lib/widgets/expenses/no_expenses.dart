import 'package:flutter/material.dart';

class NoExpenses extends StatelessWidget {
  const NoExpenses({super.key});

  @override
  Widget build(BuildContext context) {
    final extentWidth = MediaQuery.sizeOf(context).width * 0.5;
    final extentHeight = MediaQuery.sizeOf(context).height * 0.3;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/no_money.png",
            height: extentHeight,
            width: extentWidth,
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "No expenses found",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
