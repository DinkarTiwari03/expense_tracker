import 'package:expense_tracker/components/expense_summary.dart';
import 'package:expense_tracker/components/expense_tile.dart';
import 'package:expense_tracker/data/expense_data.dart';
import 'package:expense_tracker/models/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State <HomePage> createState() => _HomePageState();
}

class _HomePageState extends State <HomePage>{
    
    final newExpenseNameController = TextEditingController();
    final newExpenseAmountController = TextEditingController();



  // add new expense
  void addNewExpense(){
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text('Add new Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //expense name
            TextField(
              controller: newExpenseNameController,
            ),

            //expense amount
            TextField(
              controller: newExpenseAmountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),


          ],//children
        ),
        actions: [
          
          // save button
          MaterialButton(
            onPressed: save,
            child: const Text('Save'),
          ),
         
          //cancelbutton
          MaterialButton(
            onPressed: cancel,
            child: const Text('Cancel'),
          ),

        ],
      )
      );
  }

    //Save
    void save(){
      //create expense item
      ExpenseItem newExpense = ExpenseItem(
        name: newExpenseNameController.text, 
        amount: newExpenseAmountController.text,
        dateTime: DateTime.now(),
        );
        //add new expense

      Provider.of<ExpenseData>(context, listen: false).addNewExpense(newExpense);
      Navigator.pop(context);
      newExpenseNameController.clear();
      newExpenseAmountController.clear();
    }

    //Cancel
    void cancel(){
      Navigator.pop(context);
    }

  @override
  Widget build(BuildContext context ){
    return SafeArea(
      
      child: Consumer<ExpenseData>(
        
        builder: (context, value , child) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Center(
              child: Text(
                "Expense Tracker",
                style:TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),

                
                
              ),
            ),
          ),
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: addNewExpense,
          child: const Icon(Icons.add),
        ),
        body: ListView(
          children: [
            const SizedBox(height: 20,),
            
            // weekly summary
           ExpenseSummary(startOfWeek: value.startOfWeekDate()),
            //expense list
            ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),  
            itemCount : value.getAllExpenseList().length,
            itemBuilder: (context, index) => ExpenseTile(
            name:value.getAllExpenseList()[index].name, 
            amount: value.getAllExpenseList()[index].amount, 
            dateTime: value.getAllExpenseList()[index].dateTime,
            ),
             
      
          ),
          ],
        ),
        ),
      ),
    );

    
  }
}