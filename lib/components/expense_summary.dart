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
 //calculate max amount in bar graph
 double calculateMax(
  ExpenseData value,
   String sunday,
   String monday,
   String tuesday,
   String wednesday,
   String thursday,
   String friday,
   String saturday){

    double? max = 100;

    List<double> values = [
      value.calculateDailyExpenseSummary()[sunday]?? 0,
      value.calculateDailyExpenseSummary()[monday]?? 0,
      value.calculateDailyExpenseSummary()[tuesday]?? 0,
      value.calculateDailyExpenseSummary()[wednesday]?? 0,
      value.calculateDailyExpenseSummary()[thursday]?? 0,
      value.calculateDailyExpenseSummary()[friday]?? 0,
      value.calculateDailyExpenseSummary()[saturday]?? 0,
    ];

    //sort from smallest to largest
    values.sort();
    //get largest amount (which is at the end of the sorted list)
    //and increase the cap slightly so the graph looks almost full
    max = values.last* 1.1;
    
    return max==0? 100: max ;
 }

 // calculate the weel total
   String calculateWeekTotal(ExpenseData value,
   String sunday,
   String monday,
   String tuesday,
   String wednesday,
   String thursday,
   String friday,
   String saturday){

   List<double> values = [
      value.calculateDailyExpenseSummary()[sunday]?? 0,
      value.calculateDailyExpenseSummary()[monday]?? 0,
      value.calculateDailyExpenseSummary()[tuesday]?? 0,
      value.calculateDailyExpenseSummary()[wednesday]?? 0,
      value.calculateDailyExpenseSummary()[thursday]?? 0,
      value.calculateDailyExpenseSummary()[friday]?? 0,
      value.calculateDailyExpenseSummary()[saturday]?? 0,
    ];  
    double total = 0;
    for(int i=0;i<values.length;i++){
      total += values[i];
    }
    return total.toStringAsFixed(2);
 }


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
      builder: (context, value, child )=>   Column(
        children: [
          //week total 
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Text('Week Total: ',style: TextStyle(fontWeight: FontWeight.bold),
              ), 
              Text('₹${calculateWeekTotal(
                value, sunday,
                monday, tuesday,
                wednesday, thursday,
                friday, saturday)}'
                ),
            ],
          ),


          //bar graph
          SizedBox(
            height: 200,
            child: MyBarGraph(
              maxY: calculateMax(
                value, sunday,
                monday, tuesday,
                wednesday, thursday,
                friday, saturday ),
              sunAmount: value.calculateDailyExpenseSummary()[sunday] ?? 0,
              monAmount: value.calculateDailyExpenseSummary()[monday] ?? 0,
              tueAmount: value.calculateDailyExpenseSummary()[tuesday] ?? 0,
              wedAmount: value.calculateDailyExpenseSummary()[wednesday] ?? 0,
              thuAmount: value.calculateDailyExpenseSummary()[thursday] ?? 0,
              friAmount: value.calculateDailyExpenseSummary()[friday] ?? 0,
              satAmount: value.calculateDailyExpenseSummary()[saturday] ?? 0,
             ),
          ),
        ],
      ),
    );
  }
}