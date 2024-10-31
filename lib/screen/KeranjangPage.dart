import 'package:cafe_app/screen/model/order_model.dart';
import 'package:cafe_app/screen/service/order_service.dart';
import 'package:flutter/material.dart';

class Keranjang extends StatefulWidget {
  @override
  _KeranjangState createState() => _KeranjangState();
}

class _KeranjangState extends State<Keranjang> {
  Map<String, int> quantities = {};
  final OrderService orderService = OrderService(); // Instance dari OrderService
  List<OrderModel> orders = []; // Daftar pesanan

  @override
  void initState() {
    super.initState();
    // Inisialisasi yang lain jika perlu
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Mengambil argumen yang diteruskan dari layar sebelumnya
    quantities = ModalRoute.of(context)!.settings.arguments as Map<String, int>;
    _initializeOrders();
  }

  void _initializeOrders() {
    quantities.forEach((productName, quantity) {
      print("Menginisialisasi produk: $productName dengan kuantitas: $quantity");
      if (quantity > 0) {
        int price = getPrice(productName);
        print("Harga untuk $productName: $price");
        if (price > 0) {
          orders.add(OrderModel(productName: productName, quantity: quantity, price: price));
          orderService.addOrder(OrderModel(productName: productName, quantity: quantity, price: price));
        } else {
          print("Harga tidak valid untuk produk: $productName");
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    int subtotal = _calculateSubtotal();
    int pajak = 2000; // Biaya administrasi
    int total = subtotal + pajak; // Menghitung total

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Keranjang',
          style: TextStyle(
            color: Colors.black,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              ...orders.map((order) => _buildOrderCard(order)).toList(),
              if (orders.isEmpty) Expanded(child: Container()),
              _buildSummary(total, subtotal, pajak),
              SizedBox(height: 10),
              _buildOrderButton(),
            ],
          ),
        ),
      ),
    );
  }

  int _calculateSubtotal() {
    return orders.fold(0, (total, order) => total + order.totalPrice);
  }

  Card _buildOrderCard(OrderModel order) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        height: 85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 76,
                  width: 86,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(getImagePath(order.productName)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      order.productName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  _buildQuantityControl(order),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _buildQuantityControl(OrderModel order) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.remove_circle_outline, color: Color(0xFF057350)),
              onPressed: () {
                setState(() {
                  if (quantities[order.productName]! > 0) {
                    quantities[order.productName] = quantities[order.productName]! - 1;
                    if (quantities[order.productName]! == 0) {
                      orderService.removeOrder(order.productName); // Hapus dari OrderService jika kuantitas nol
                      orders.remove(order); // Hapus dari daftar pesanan
                    } else {
                      orderService.addOrder(OrderModel(
                        productName: order.productName,
                        quantity: quantities[order.productName]!,
                        price: order.price,
                      )); // Tambahkan kembali
                    }
                  }
                });
              },
            ),
            Text('${order.quantity}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            IconButton(
              icon: Icon(Icons.add_circle_outline, color: Color(0xFF057350)),
              onPressed: () {
                setState(() {
                  quantities[order.productName] = quantities[order.productName]! + 1;
                  orderService.addOrder(OrderModel(
                    productName: order.productName,
                    quantity: quantities[order.productName]!,
                    price: order.price,
                  )); // Tambahkan pesanan ke OrderService
                });
              },
            ),
            Text('Rp ${order.price}', style: TextStyle(fontSize: 16, color: Color(0xFF057350), fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
  
  Container _buildSummary(int total, int subtotal, int pajak) {
    return Container(
      height: 190,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 3,
            offset: Offset(0, 4),
            blurRadius: 7,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          _buildSummaryRow('Sub Total', 'Rp $subtotal'),
          SizedBox(height: 10),
          _buildSummaryRow('Pajak', 'Rp $pajak'),
          SizedBox(height: 20),
          Divider(thickness: 1, color: Color(0xFFD9D9D9)),
          _buildSummaryRow('Total', 'Rp $total', isTotal: true),
        ],
      ),
    );
  }

  Row _buildSummaryRow(String title, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: isTotal ? Color(0xFF057350) : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: isTotal ? Color(0xFF057350) : Color(0xFFD9D9D9),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderButton() {
  return Center(
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF057350),
        padding: EdgeInsets.symmetric(horizontal: 150, vertical: 17),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/meja');
      },
      child: Text(
        'Pesan',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}


  int getPrice(String itemName) {
    Map<String, int> prices = {
      'Dalgona Coffee': 15000,
      'Banana Milkshake': 20000,
      'Blueberry Bread': 23000,
      'Beef Mushroom Pizza': 35000,
      'Berry cinnamon roll': 23000,
      'Cinnamon tea': 17000,
    };
    return prices[itemName] ?? 0;
  }

  String getImagePath(String itemName) {
    Map<String, String> images = {
      'Dalgona Coffee': 'assets/dalgona.png',
      'Banana Milkshake': 'assets/milkshake.png',
      'Blueberry Bread': 'assets/bread.png',
      'Beef Mushroom Pizza': 'assets/pizza.png',
      'Berry cinnamon roll': 'assets/cinnamon.png',
      'Cinnamon tea': 'assets/tea.png',
    };
    return images[itemName] ?? 'assets/default.png';
  }
}
