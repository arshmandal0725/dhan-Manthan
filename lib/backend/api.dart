import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhan_manthan/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class API {
  static final currentUser = FirebaseAuth.instance.currentUser;
  static final firestore = FirebaseFirestore.instance;

  static Future<void> checkUserExist(String uid) async {
    final doc = await firestore.collection('users').doc(uid).get();
    final _isExist = doc.exists;
    if (!_isExist) {
      print('*****Creating User****');
      UserModel user = UserModel(
        uid: uid,
        name: currentUser!.displayName!,
        email: currentUser!.email!,
        image: currentUser!.photoURL,
      );
      await firestore
          .collection('users')
          .doc(currentUser!.uid)
          .set(user.toMap());
    } else {
      print('*****User Exists****');
    }
  }
}
