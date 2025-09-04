import 'package:dhan_manthan/backend/user_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/new_debts_model.dart';

class DebtsNotifier extends AsyncNotifier<List<Debt>> {
  @override
  Future<List<Debt>> build() async {
    final uid = UserAPI.firebaseAuth.currentUser!.uid;
    final snapshot = await UserAPI.fireStore
        .collection('users')
        .doc(uid)
        .collection('debts')
        .get();

    return snapshot.docs.map((doc) => Debt.fromJson(doc.data())).toList();
  }

  Future<void> addDebt(Debt debt) async {
    state = const AsyncValue.loading();
    await UserAPI.addDebts(debt);
    state = AsyncValue.data([...state.value ?? [], debt]);
  }

  Future<void> removeDebt(Debt debt) async {
    state = const AsyncValue.loading();
    await UserAPI.removeDebts(debt);
    state = AsyncValue.data(
      (state.value ?? []).where((d) => d.id != debt.id).toList(),
    );
  }
}

final debtsProvider = AsyncNotifierProvider<DebtsNotifier, List<Debt>>(
  DebtsNotifier.new,
);
