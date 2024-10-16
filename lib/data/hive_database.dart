import 'package:expense_tracker/models/expense_item.dart';
import 'package:hive/hive.dart';

class HiveDatabase {
  // reference our box
  final _myBox = Hive.box("expense_database");

  //write data
  void saveData(List <ExpenseItem> allExpense){
   /*
     Hive can only store string and datetime, not custom object like ExpenseItem.
     so lets convert ExpenseItem objects into types that can be stored in our DB
    
     allExpense = [
       ExpenseItem(name/amount/dateTime)
       ..


     ]
     ->


      [
       [name,amount,dateTime],
        ..
      ]
     */

    List<List<dynamic>> allExpensesFormatted =[];

    for(var expense in allExpense){
      //convert each expenseItem into a list of storable types (string,dateTime..)
      List <dynamic> expenseFormatted =[
        expense.name,
        expense.amount,
        expense.dateTime,
      ];
      allExpensesFormatted.add(expenseFormatted);
    }

    //finally lets store in our database!
    _myBox.put("ALL_EXPENSES", allExpensesFormatted);
  }

  //read data
 List <ExpenseItem> readData(){
    /*
      Data is stored in hive as a list of strings + dateTime 
      so lets convert our  data into ExpenseItem objects

      savedData = 
      [
        [name, amount,dateTime],      
        ..
      ]
      -> 
     [
      
       ExpenseItem (name/amount/dateTime),
       ..

     ]

    
    */

    List savedExpenses = _myBox.get("ALL_EXPENSES") ?? [];
    List <ExpenseItem> allExpenses =[];
    for(int i=0;i< savedExpenses.length;i++){
        //collect individual expenses data
        String name = savedExpenses[i][0];
        String amount = savedExpenses[i][1];
        DateTime dateTime = savedExpenses[i][2];

        //create expense item
         ExpenseItem expense =
           ExpenseItem(
            name: name, 
            amount: amount,
            dateTime: dateTime
            );
         
         // add expense to overall list of expenses
          allExpenses.add(expense);   
        }
        return allExpenses; 
    }

}