import 'package:expense_tracker/bar%20graph/bar_graph.dart';
import 'package:expense_tracker/data/expense_data.dart';
import 'package:expense_tracker/datetime/date_time_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class ExpenseSummary extends StatelessWidget {
  final DateTime startOfWeek;
  const ExpenseSummary({
    super.key,
    required this.startOfWeek,
  });

  @override
  Widget build(BuildContext context) {
    // get yyyymmdd for each day of tyhis week
    String sunday = convertDateTineToString(startOfWeek.add(const Duration(days: 0)));
    String monday = convertDateTineToString(startOfWeek.add(const Duration(days: 1)));
    String tuesday = convertDateTineToString(startOfWeek.add(const Duration(days: 2)));
    String wednesday = convertDateTineToString(startOfWeek.add(const Duration(days:3)));
    String thursday = convertDateTineToString(startOfWeek.add(const Duration(days: 4)));
    String friday = convertDateTineToString(startOfWeek.add(const Duration(days: 5)));
    String saturday = convertDateTineToString(startOfWeek.add(const Duration(days: 6)));

    return Consumer<ExpenseData>(
      builder: (context, value, child )=>   SizedBox(
        height: 200,
        child: MyBarGraph(
          maxY: 100,
          sunAmount: value.calculateDailyExpenseSummary()[sunday] ?? 0,
          monAmount: value.calculateDailyExpenseSummary()[monday] ?? 0,
          tueAmount: value.calculateDailyExpenseSummary()[tuesday] ?? 0,
          wedAmount: value.calculateDailyExpenseSummary()[wednesday] ?? 0,
          thuAmount: value.calculateDailyExpenseSummary()[thursday] ?? 0,
          friAmount: value.calculateDailyExpenseSummary()[friday] ?? 0,
          satAmount: value.calculateDailyExpenseSummary()[saturday] ?? 0,
         ),
      ),
    );
  }
}