import 'package:dhan_manthan/constant.dart';
import 'package:dhan_manthan/providers/expense_provider.dart';
import 'package:dhan_manthan/screens/add_expense/expense_list.dart';
import 'package:dhan_manthan/screens/add_expense/new_expense.dart';
import 'package:dhan_manthan/widgets/chart/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseHomescreen extends ConsumerWidget {
  const ExpenseHomescreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expenseProvider);
    final width = MediaQuery.of(context).size.width;

    return expenses.when(
      data: (list) {
        Widget mainContent = const Center(
          child: Text(
            "No Expenses to Show, try adding some",
            style: TextStyle(fontSize: 18),
          ),
        );

        if (list.isNotEmpty) {
          mainContent = (width <= 600)
              ? Column(
                  children: [
                    Chart(expenses: list),
                    Expanded(
                      child: ExpenseList(list, (exp) {
                        ref.read(expenseProvider.notifier).removeExpense(exp);
                      }),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(child: Chart(expenses: list)),
                    Expanded(
                      child: ExpenseList(list, (exp) {
                        ref.read(expenseProvider.notifier).removeExpense(exp);
                      }),
                    ),
                  ],
                );
        }

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: bgColor,
            title: const Text(
              'Track Your Expense',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  if (width <= 600) {
                    showModalBottomSheet(
                      context: context,
                      builder: (ctx) => NewExpense(
                        (exp) =>
                            ref.read(expenseProvider.notifier).addExpense(exp),
                      ),
                    );
                  } else {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (ctx) => NewExpense(
                        (exp) =>
                            ref.read(expenseProvider.notifier).addExpense(exp),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.add, color: Colors.black),
              ),
            ],
            centerTitle: false,
          ),
          body: mainContent,
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text("Error: $e")),
    );
  }
}
