import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhan_manthan/models/new_debts_model.dart';
import 'package:dhan_manthan/models/new_expense.dart';
import 'package:dhan_manthan/models/user_model.dart' show UserModel;
import 'package:firebase_auth/firebase_auth.dart';

class UserAPI {
  static final firebaseAuth = FirebaseAuth.instance;
  static final fireStore = FirebaseFirestore.instance;

  static Future<bool> checkIfExist() async {
    final uid = firebaseAuth.currentUser!.uid;
    final isExist = await fireStore.collection('users').doc(uid).get();
    return isExist.exists;
  }

  static Future<void> addUser() async {
    final uid = firebaseAuth.currentUser!.uid;
    final UserModel user = UserModel(
      uid: uid,
      image: firebaseAuth.currentUser!.photoURL,
      name: firebaseAuth.currentUser!.displayName!,
      email: firebaseAuth.currentUser!.email!,
    );
    await fireStore.collection('users').doc(uid).set(user.toMap());
  }

  static Future<void> addExpense(Expense expense) async {
    await fireStore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('expense')
        .doc(expense.id)
        .set(expense.toJson());
  }

  static Future<void> removeExpense(Expense expense) async {
    await fireStore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('expense')
        .doc(expense.id)
        .delete();
  }

  static Future<void> addDebts(Debt debts) async {
    await fireStore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('debts')
        .doc(debts.id)
        .set(debts.toJson());
  }

  static Future<void> removeDebts(Debt debts) async {
    await fireStore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('debts')
        .doc(debts.id)
        .delete();
  }
}
