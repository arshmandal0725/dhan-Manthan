import 'package:dhan_manthan/constant.dart';
import 'package:dhan_manthan/models/new_debts_model.dart';
import 'package:dhan_manthan/providers/debts_provider.dart';
import 'package:dhan_manthan/screens/add_debts/debts_list.dart';
import 'package:dhan_manthan/screens/add_debts/new_debts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeDebt extends ConsumerWidget {
  const HomeDebt({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debtsAsync = ref.watch(debtsProvider); // 👈 FutureProvider
    final width = MediaQuery.of(context).size.width;

    void add(Debt debt) {
      ref.read(debtsProvider.notifier).addDebt(debt);
    }

    void remove(Debt debt) {
      ref.read(debtsProvider.notifier).removeDebt(debt);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 1),
          content: Text("Debt Deleted"),
        ),
      );
    }

    return Scaffold(
      backgroundColor: bgColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: const Text(
          'Track Your Debt',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (width <= 600) {
                showModalBottomSheet(
                  context: context,
                  builder: (ctx) => NewExpense(add),
                );
              } else {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (ctx) => NewExpense(add),
                );
              }
            },
            icon: const Icon(Icons.add, color: Colors.black),
          ),
        ],
        centerTitle: false,
      ),
      body: debtsAsync.when(
        data: (debts) {
          if (debts.isEmpty) {
            return const Center(
              child: Text(
                "No Debt to Show, Try to add some",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return (width <= 600)
              ? Column(children: [Expanded(child: ExpenseList(debts, remove))])
              : Row(children: [Expanded(child: ExpenseList(debts, remove))]);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
      ),
    );
  }
}
