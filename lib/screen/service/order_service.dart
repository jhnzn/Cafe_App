import 'package:cafe_app/screen/model/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderService {
  final CollectionReference orderCollection = FirebaseFirestore.instance.collection('Order');

  // Menambahkan pesanan ke dalam Firestore
  Future<void> addOrder(OrderModel order) async {
    try {
      await orderCollection.add(order.toFirestore());
    } catch (e) {
      print('Error adding order: $e');
      throw e; // Lempar kesalahan jika terjadi
    }
  }

  // Menghapus pesanan berdasarkan ID dokumen
  Future<void> removeOrder(String docId) async {
    try {
      await orderCollection.doc(docId).delete();
    } catch (e) {
      print('Error removing order: $e');
      throw e; // Lempar kesalahan jika terjadi
    }
  }

  // Mendapatkan semua pesanan dari Firestore
  Stream<List<OrderModel>> getOrders() {
    return orderCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>?; // pastikan untuk mendapatkan data dengan aman
        return data != null ? OrderModel.fromFirestore(data) : null; 
      }).whereType<OrderModel>().toList(); // filter null
    });
  }

  // Menghitung total harga semua pesanan
  Future<int> getTotalPrice() async {
    final snapshot = await orderCollection.get();
    int totalPrice = 0;
    for (var doc in snapshot.docs) {
      final order = OrderModel.fromFirestore(doc.data() as Map<String, dynamic>);
      totalPrice += order.totalPrice; // Menghitung total harga
    }
    return totalPrice;
  }

  // Menghapus semua pesanan dari Firestore
  Future<void> clearOrders() async {
    try {
      final snapshot = await orderCollection.get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print('Error clearing orders: $e');
      throw e; // Lempar kesalahan jika terjadi
    }
  }
}
