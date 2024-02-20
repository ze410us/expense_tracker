import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses/chart/chart_legend.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final currencyFormatter = NumberFormat.simpleCurrency(locale: "en-US");

class ExpensesChart extends StatefulWidget {
  const ExpensesChart(this.expenseBuckets, {super.key});
  final Map<Category, double> expenseBuckets;

  @override
  _ExpensesChartState createState() => _ExpensesChartState();
}

class _ExpensesChartState extends State<ExpensesChart> {
  Color _getColorByCategory(Category cat) {
    return switch (cat) {
      Category.food => Colors.orangeAccent,
      Category.leisure => Colors.greenAccent,
      Category.travel => Colors.blueAccent,
      Category.work => Colors.blueGrey.shade200,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: PieChart(
            PieChartData(
              centerSpaceRadius: 30,
              sectionsSpace: 5,
              sections: [
                for (MapEntry<Category, double> eb
                    in widget.expenseBuckets.entries)
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
                          color:
                              Theme.of(context).textTheme.titleMedium!.color!,
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
                  in widget.expenseBuckets.entries) ...[
                ChartLegend(
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
    );
  }
}
