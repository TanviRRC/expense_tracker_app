import 'package:expense_tracker_app/chart/chart.dart';
import 'package:expense_tracker_app/widgets/expense_list/expenses_list.dart';
import 'package:expense_tracker_app/widgets/new_expense.dart';
import 'package:flutter/material.dart';

import 'models/expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpense = [
    Expense(
        title: 'Flutter Course',
        amount: 21.99,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: 'Movie',
        amount: 10.99,
        date: DateTime.now(),
        category: Category.leisure),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      constraints: BoxConstraints(
        minWidth: 0,
        maxWidth: MediaQuery.of(context).size.width,
      ),
      context: context,
      builder: (ctx) => NewExpense(
        onAddExpense: _addExpense,
      ),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpense.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndexNo  = _registeredExpense.indexOf(expense);
    setState(() {
      _registeredExpense.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
            content: const Text('Expense Deleted'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: (){
              setState(() {
                _registeredExpense.insert(expenseIndexNo, expense);
              });
            },
          ),

        )
    );
  }

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;

    Widget mainContent = const Center(
      child: Text("No expenses found. Start adding some expense!"),
    );

    if(_registeredExpense.isNotEmpty){
      mainContent = ExpensesList(
          expenses: _registeredExpense,
          onRemoveExpense: _removeExpense,);
    }


    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Expense Tracker'),
        actions: [
          IconButton(
              onPressed: _openAddExpenseOverlay, icon: const Icon(Icons.add))
        ],
      ),
      body: width < 600 ? Column(
        children: [
          Chart(expenses: _registeredExpense),
          Expanded(
              child: mainContent
          ),
        ],
      ) : Row(
        children: [
          Expanded(child: Chart(expenses: _registeredExpense)),
          Expanded(
              child: mainContent
          ),
        ],
      )
    );
  }
}
