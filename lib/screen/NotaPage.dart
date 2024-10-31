import 'package:cafe_app/screen/KeranjangPage.dart';
import 'package:cafe_app/screen/LoginPage.dart';
import 'package:cafe_app/screen/OrderPage.dart';
import 'package:cafe_app/screen/model/meja_model.dart';
import 'package:cafe_app/screen/model/order_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Nota extends StatefulWidget {
  final String? nomormeja;
  final String? productName;
  final Map<String, int> quantities;

  const Nota(
      {super.key, this.nomormeja, required this.quantities, this.productName});

  @override
  State<Nota> createState() => _NotaState();
}

class _NotaState extends State<Nota> {
  late Future<MejaModel> mejaFuture;
  late Future<List<OrderModel>> orderFuture;

  @override
  void initState() {
    super.initState();
    mejaFuture = getMeja(widget.nomormeja);
    orderFuture = getOrders(); // Panggil getOrders di sini
  }

  Future<MejaModel> getMeja(String? nomorMeja) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Meja')
        .where('NomorMeja', isEqualTo: nomorMeja)
        .get();
    if (snapshot.docs.isNotEmpty) {
      return MejaModel.fromFirestore(
          snapshot.docs.first.data(), snapshot.docs.first.id);
    } else {
      throw Exception('Meja tidak ditemukan');
    }
  }

  Future<List<OrderModel>> getOrders() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('Orders').get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return OrderModel.fromFirestore(data);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF057350),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              const Text(
                'Nota Transaksi',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Image.asset(
                    'assets/nota.png',
                    width: 500,
                    height: 600,
                  ),
                  Positioned(
                    top: 70,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: const Color(0xFF057350),
                          size: 60,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Transaksi Berhasil',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 180,
                    child: Container(
                      width: 272,
                      height: 1,
                      color: const Color(0xFFE9EFEC),
                    ),
                  ),
                  Positioned(
                    top: 180,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          'Wikusama Cafe',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 240,
                    left: 70,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tanggal',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFAEAEAE),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          DateTime.now().toString().split(' ')[0],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Nama: Trisha Perwira',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        FutureBuilder<List<OrderModel>>(
                          future: orderFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Text('No orders found');
                            } else {
                              final orders = snapshot.data!;
                              final total = orders.fold(
                                  0,
                                  (sum, order) =>
                                      sum + order.price * order.quantity);
                              return Text(
                                'Rp $total',
                                style: const TextStyle(
                                    fontSize: 17,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              );
                            }
                          },
                        ),
                        FutureBuilder<MejaModel>(
                          future: mejaFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.hasData) {
                              final meja = snapshot.data!;
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(right: 180),
                                    child: Text(
                                      'Meja',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFFAEAEAE),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    meja.nomorMeja,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFFAEAEAE),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return const Text('No table information found');
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        FutureBuilder<List<OrderModel>>(
                          future: orderFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              final orders = snapshot.data!;
                              return Column(
                                children: orders.map((order) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 160),
                                        child: Text(
                                          order.productName,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFFAEAEAE),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${order.quantity}x',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFFAEAEAE),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 140),
                              child: Text(
                                'Total',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFAEAEAE),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            FutureBuilder<List<OrderModel>>(
                              future: orderFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return const Text('No total found');
                                } else {
                                  final orders = snapshot.data!;
                                  final total = orders.fold(
                                      0,
                                      (sum, order) =>
                                          sum + order.price * order.quantity);
                                  return Text(
                                    'Rp $total',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF057350),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 100, vertical: 16),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  onPressed: () {
                                    // Navigasi ke halaman awal
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const OrderPage()),
                                    );
                                  },
                                  child: const Text(
                                    'Cetak',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
               const SizedBox(height: 50),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFC90000),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  // Navigasi ke halaman login
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()),
                                  );
                                },
                                child: const Text(
                                  'Logout',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
            ],
          ),
        ),
      ),
    );
  }
}
