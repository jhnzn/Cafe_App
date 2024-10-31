import 'package:cafe_app/screen/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('User');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<UserModel>> getUsers() async {
    final snapshot = await _userCollection.get();

    return snapshot.docs.map((doc) {
      return UserModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  Future<void> addUser(UserModel user) async {
    await _firestore.collection('User').add({
      'Nama': user.Nama,
      'Role': user.Role,
      'Password': user.Password, // Menyimpan password saat menambahkan user
    });
  }

  Future<void> updateUser(String docId, UserModel user) async {
  try {
    final docRef = _firestore.collection('users').doc(docId); // Pastikan nama koleksi benar
    final docSnapshot = await docRef.get();

    if (!docSnapshot.exists) {
      throw Exception('Document does not exist');
    }

    await docRef.set(user.toFirestore(), SetOptions(merge: true));
  } catch (e) {
    print('Error updating user: $e');
    throw e; // Lempar kembali kesalahan
  }
}


  // Fungsi untuk menghapus pengguna dari Firestore
  Future<void> deleteUser(String docId) async {
    try {
      await _userCollection.doc(docId).delete();
      print('User deleted berhasil');
    } catch (e) {
      print('gagal deleting user: $e');
    }
  }

   static Future<UserModel?> login(String Nama, String Password) async {
  try {
    // Lakukan query untuk mencocokkan Nama dan Password di Firestore
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('User')
        .where('Nama', isEqualTo: Nama)
        .where('Password', isEqualTo: Password)
        .get();

    if (snapshot.docs.isNotEmpty) {
      // Jika ada pengguna yang ditemukan, ambil data pengguna
      print('User found: ${snapshot.docs.first.data()}');
      return UserModel.fromFirestore(snapshot.docs.first.data() as Map<String, dynamic>, snapshot.docs.first.id);
    } else {
      print('No user found');
    }
  } catch (e) {
    print('Error during login: $e');
  }
  return null; // Jika tidak ada pengguna yang ditemukan atau ada kesalahan
}
}
