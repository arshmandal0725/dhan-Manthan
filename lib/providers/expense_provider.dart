import 'package:dhan_manthan/backend/user_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/new_expense.dart';

class ExpenseNotifier extends AsyncNotifier<List<Expense>> {
  @override
  Future<List<Expense>> build() async {
    // Load initial data
    final uid = UserAPI.firebaseAuth.currentUser!.uid;
    final snapshot = await UserAPI.fireStore
        .collection('users')
        .doc(uid)
        .collection('expense')
        .get();

    return snapshot.docs.map((doc) => Expense.fromJson(doc.data())).toList();
  }

  Future<void> addExpense(Expense expense) async {
    state = const AsyncValue.loading();
    await UserAPI.addExpense(expense);
    state = AsyncValue.data([...state.value ?? [], expense]);
  }

  Future<void> removeExpense(Expense expense) async {
    state = const AsyncValue.loading();
    await UserAPI.removeExpense(expense);
    state = AsyncValue.data(
      (state.value ?? []).where((e) => e.id != expense.id).toList(),
    );
  }
}

final expenseProvider = AsyncNotifierProvider<ExpenseNotifier, List<Expense>>(
  ExpenseNotifier.new,
);
