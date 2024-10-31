import 'package:cafe_app/screen/model/produk_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProdukService {
  final CollectionReference produkCollection =
      FirebaseFirestore.instance.collection('Produk');
            final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Stream<List<ProdukModel>> getAllProduk() {
    return produkCollection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => ProdukModel.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id))
        .toList());
  }

  // Menambahkan produk baru
  Future<void> addProduk(ProdukModel produk) async {
    await _firestore.collection('Produk').add({
      'Nama Produk':produk.NamaProduk,
      'Price': produk.Price,
      'Kategori':produk.Kategori,
      'ImageUrl':produk.ImageUrl
    });
  }

  // Memperbarui produk
  Future<void> updateProduk(String docId, ProdukModel produk) async {
    try {
      final docRef = _firestore.collection('Produk').doc(docId);
      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        throw Exception('Document does not exist');
      }

      await docRef.set(produk.toFirestore(), SetOptions(merge: true));
    } catch (e) {
      print('Error updating user: $e');
      throw e; // Lempar kembali kesalahan
    }
  }

  // Menghapus produk
  Future<void> deleteProduk(String docId) async {
    try {
      await produkCollection.doc(docId).delete();
      print('Produk deleted successfully');
    } catch (e) {
      print('Failed to delete produk: $e');
    }
  }
}
