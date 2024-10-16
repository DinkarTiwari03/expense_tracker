import 'package:expense_tracker/components/expense_summary.dart';
import 'package:expense_tracker/components/expense_tile.dart';
import 'package:expense_tracker/data/expense_data.dart';
import 'package:expense_tracker/models/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final newExpenseNameController = TextEditingController();
  final newExpenseAmountController = TextEditingController();

  @override
 void initState(){
  super.initState();

  //prepare data on startup
  Provider.of<ExpenseData>(context, listen: false).prepareData();
 }

  // Add new expense dialog
  void addNewExpense() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Add New Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            // Expense name input

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: newExpenseNameController,
                decoration: InputDecoration(
                  labelText: "Expense Name",
                  labelStyle: const TextStyle(
                    color: Colors.black,
                  ),

                  border: OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),

                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),

            // Expense amount input

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: newExpenseAmountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: "Amount",
                  labelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          // Save button
          MaterialButton(
            onPressed: save,
            child: const Text('Save'),
          ),
          // Cancel button
          MaterialButton(
            onPressed: cancel,
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
  //delete expense 
  void deleteExpenses(ExpenseItem expense){
    Provider.of<ExpenseData>(context,listen: false).deleteExpense(expense);
  }
  
  // Save function with validation
  void save() {
    String expenseName = newExpenseNameController.text.trim();
    String expenseAmount = newExpenseAmountController.text.trim();

    // Validate inputs
    if (expenseName.isEmpty || expenseAmount.isEmpty) {
      // Show an error if any field is empty
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Error'),
          content: const Text('Please enter both the expense name and amount.'),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return; // Prevent saving if fields are empty
    }

    // Convert amount to a number
    double? amount = double.tryParse(expenseAmount);
    if (amount == null || amount <= 0) {
      // Show an error if the amount is invalid
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Please enter a valid expense amount.'),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return; // Prevent saving if amount is invalid
    }

    // Create the expense item
    ExpenseItem newExpense = ExpenseItem(
      name: expenseName,
      amount: amount.toString(),
      dateTime: DateTime.now(),
    );

    // Add the new expense to the provider
    Provider.of<ExpenseData>(context, listen: false).addNewExpense(newExpense);

    // Close the dialog and clear the text fields
    Navigator.pop(context);
    newExpenseNameController.clear();
    newExpenseAmountController.clear();
  }

  // Cancel function to close the dialog
  void cancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<ExpenseData>(
        builder: (context, value, child) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Center(
              child: Text(
                "Expense Tracker",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          backgroundColor: Colors.white,
          floatingActionButton: FloatingActionButton(
            onPressed: addNewExpense,
            backgroundColor: Colors.grey,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          body: ListView(
            children: [
              const SizedBox(height: 20),
              // Weekly summary
              ExpenseSummary(startOfWeek: value.startOfWeekDate()),
              const SizedBox(height: 12),
              // Expense list
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: value.getAllExpenseList().length,
                itemBuilder: (context, index) => ExpenseTile(
                  name: value.getAllExpenseList()[index].name,
                  amount: value.getAllExpenseList()[index].amount,
                  dateTime: value.getAllExpenseList()[index].dateTime,
                  deleteTapped: (p0) => deleteExpenses(value.getAllExpenseList()[index]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*import 'package:expense_tracker/components/expense_summary.dart';
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
        backgroundColor: Colors.white,
        title: const Text('Add New Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            
            //expense name
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: newExpenseNameController,
                decoration: InputDecoration(
                    labelText:"Expenses Name" ,
                    labelStyle: const TextStyle(
                      color: Colors.black,
                    ), 
                    border: OutlineInputBorder(
                    
                      // borderRadius: BorderRadius.circular(20),
                      
                    ),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                        color: Colors.black,
                     ),
                    ),
              
                    focusedBorder: const OutlineInputBorder(
                       borderSide: BorderSide(
                      color: Colors.black,
                     ),
                    ),
                  ),
                ),
            ),
              
            //expense amount
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: newExpenseAmountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                    labelText:"Amount" ,
                    labelStyle: const TextStyle(
                      color: Colors.black,
                    ), 
                    border: OutlineInputBorder(
                    
                      borderRadius: BorderRadius.circular(10),
                      
                    ),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                        color: Colors.black,
                     ),
                    ),
              
                    focusedBorder: const OutlineInputBorder(
                       borderSide: BorderSide(
                      color: Colors.black,
                     ),
                    ),
                  ),
                ),
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
          backgroundColor: Colors.grey,
          child: const Icon(
            Icons.add,
            color: Colors.white,
            ),
        ),
        body: ListView(
          children: [
            const SizedBox(height: 20,),
            
            // weekly summary
           ExpenseSummary(startOfWeek: value.startOfWeekDate()),
           const SizedBox(height: 12,),
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
*/