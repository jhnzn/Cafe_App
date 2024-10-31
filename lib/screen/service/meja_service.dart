import 'package:cafe_app/screen/model/meja_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MejaService {
  final CollectionReference mejaCollection = FirebaseFirestore.instance.collection('Meja');
          final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Stream<List<MejaModel>> getAllMeja() {
    return mejaCollection.snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => MejaModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id)).toList());
  }

  Future<void> addMeja(MejaModel meja) async {
     await _firestore.collection('Meja').add({
      'NomorMeja': meja.nomorMeja,
      'Kapasitas': meja.kapasitas,
      'Status':meja.status
    });
  }

  Future<void> updateMeja(String docId, MejaModel meja) async {
    try {
      final docRef = _firestore.collection('Meja').doc(docId);
      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        throw Exception('Document does not exist');
      }

      await docRef.set(meja.toFirestore(), SetOptions(merge: true));
    } catch (e) {
      print('Error updating meja: $e');
      throw e; // Lempar kembali kesalahan
    }
  }

  // Fungsi untuk menghapus pengguna dari Firestore
  Future<void> deleteMeja(String docId) async {
    try {
      await mejaCollection.doc(docId).delete();
      print('User deleted berhasil');
    } catch (e) {
      print('gagal deleting user: $e');
    }
  }
}
