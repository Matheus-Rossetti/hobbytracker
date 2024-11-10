import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference hobbiesCollection =
      FirebaseFirestore.instance.collection('hobbies');

  //* CREATE new hobby
  Future<void> createHobby(String hobbyName, String timePracticed) async {
    await hobbiesCollection.add({
      'hobbyName': hobbyName,
      'timePracticed': timePracticed,
    });
    return;
  }

//* READ hobbies

  Stream<QuerySnapshot> getHobbies() {
    return hobbiesCollection.snapshots();
  }

//* UPDATE existing hobbie name and/or time practiced

  Future<void> updateHobby(
      String docID, String hobbyName, String timePracticed) async {
    await hobbiesCollection.doc(docID).update({
      'hobbyName': hobbyName,
      'timePracticed': timePracticed,
    });
    return;
  }

//* DELETE existing hobby
}
