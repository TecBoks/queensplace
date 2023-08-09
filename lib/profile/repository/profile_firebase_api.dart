import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseProfileAPI {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateDataUser(String userId, value) {
    return _firestore
        .collection("users")
        .doc(userId)
        .update((value["type"] == "worker")
            ? {
                'uid': value["uid"],
                'name': value["name"],
                'phone': value["phone"],
                'birthDay': value["birthDay"],
                'email': value["email"],
                'services': value["services"],
                'photoURL': value["photoURL"],
                'type': value["type"]
              }
            : {
                'uid': value["uid"],
                'name': value["name"],
                'phone': value["phone"],
                'birthDay': value["birthDay"],
                'email': value["email"],
                'redeemedPoints': value["redeemedPoints"],
                'accumulatedPoints': value["accumulatedPoints"],
                'photoURL': value["photoURL"],
                'type': value["type"]
              });
  }
}
