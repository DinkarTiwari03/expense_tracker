import 'package:expense_tracker/data/hive_database.dart';
import 'package:expense_tracker/datetime/date_time_helper.dart';
import 'package:expense_tracker/models/expense_item.dart';
import 'package:flutter/material.dart';

class ExpenseData extends ChangeNotifier {
  //list of all expenses

 List <ExpenseItem> overallExpenseList =[];

  //get expenses list

 List <ExpenseItem> getAllExpenseList(){
   return overallExpenseList;
 }
 // prepare data to display
 final db = HiveDatabase();
 void prepareData(){
  //if there exists data, get it
  if(db.readData().isNotEmpty){
    overallExpenseList = db.readData();

  }
 }

  //add new expense
   
   void addNewExpense(ExpenseItem newExpense){
    overallExpenseList.add(newExpense);
    notifyListeners();
    db.saveData(overallExpenseList);
   }
  

  //delete expenses

  void deleteExpense(ExpenseItem expense){
    overallExpenseList.remove(expense);
    notifyListeners();
    db.saveData(overallExpenseList);
  }

  // get weekly (mon, tues, etc) from s dateTime object
  String getDayName(DateTime dateTime ){
    switch(dateTime.weekday){
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
         return '';

    }
  }
  //get the date for the week (sunday)
   
   DateTime startOfWeekDate(){
    DateTime ? startOfWeek;

  // get today date
   DateTime today = DateTime.now();
  
  // go backwards from today to find sunday
  for(int i=0; i<7;i++){
    if (getDayName(today.subtract(Duration(days: i))) =='Sun'){
      startOfWeek = today.subtract(Duration(days: i));
    }
  }
  return startOfWeek!;
   }





  /*
    convert overall list of the expenses into a daily expense summary
   
    eg: 
        overallExpenseList = [
          [ food, 2024/01/30, $10],
          [hat , 2024/01/31, %20],
          [food, 2024/01/01, $30],
          [food, 2024/02/02, $55],
          [food, 2024/02/03, $60],
          [food, 2024/02/04, $50],
          [food, 2024/02/05, $40],
          [food, 2024/02/06, $30],
        ]
    
     -> 
     DailyExpenseSummary =

          [20240130, $10],
          [20240131, %20],
          [20240101, $30],
          [20240202, $55],
          [20240203, $60],
          [20240204, $50],
          [20240205, $40],
          [20240206, $30],

     
   */

 Map<String, double> calculateDailyExpenseSummary(){
  // ignore: non_constant_identifier_names
  Map <String, double> DailyExpenseSummary ={
    //date (yyyymmdd) : amountTotalForDay
  };

  for(var expense in overallExpenseList ){
    String date = convertDateTineToString(expense.dateTime);
    double amount = double.parse(expense.amount);

    if( DailyExpenseSummary.containsKey(date)){
      double currentAmount =DailyExpenseSummary[date]!;
      currentAmount += amount;
      DailyExpenseSummary[date] = currentAmount;
    }
   else{
    DailyExpenseSummary.addAll({date: amount});

   }


   }

   return DailyExpenseSummary;
  }

}