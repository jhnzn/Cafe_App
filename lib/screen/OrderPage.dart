import 'package:cafe_app/screen/model/order_model.dart';
import 'package:cafe_app/screen/service/order_service.dart';
import 'package:flutter/material.dart';


class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<OrderPage> {
  final OrderService _orderService = OrderService(); // Inisialisasi service
  String? selectedFilter;
  Map<String, int> quantities = {
    'Dalgona Coffee': 0,
    'Banana Milkshake': 0,
    'Blueberry Bread': 0,
    'Beef Mushroom Pizza': 0,
    'Berry cinnamon roll': 0,
    'Cinnamon tea': 0,
  };

  // Callback untuk mengupdate jumlah di Keranjang
  void updateQuantity(String productName, int quantity) {
    setState(() {
      quantities[productName] = quantity;
    });
  }

  List<Map<String, String>> product = [
    {
      'productName': 'Dalgona Coffee',
      'price': 'Rp 15000',
      'Kategori': 'Minuman',
      'imagePath': 'assets/dalgona.png'
    },
    {
      'productName': 'Banana Milkshake',
      'price': 'Rp 20000',
      'Kategori': 'Minuman',
      'imagePath': 'assets/milkshake.png'
    },
    {
      'productName': 'Blueberry Bread',
      'price': 'Rp 23000',
      'Kategori': 'Makanan',
      'imagePath': 'assets/bread.png'
    },
    {
      'productName': 'Beef Mushroom Pizza',
      'price': 'Rp 35000',
      'Kategori': 'Makanan',
      'imagePath': 'assets/pizza.png'
    },
    {
      'productName': 'Berry cinnamon roll',
      'price': 'Rp 23000',
      'Kategori': 'Makanan',
      'imagePath': 'assets/roll.png'
    },
    {
      'productName': 'Cinnamon tea',
      'price': 'Rp 17000',
      'Kategori': 'Minuman',
      'imagePath': 'assets/tea.png'
    },
  ];

  // Fungsi untuk menambah order ke service
  void _addOrder(String productName, int quantity, int price) {
    if (quantity > 0) {
final order = OrderModel(productName: productName, quantity: quantity, price: price);
      _orderService.addOrder(order);
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: const EdgeInsets.only(top: 20), // Tambahkan margin atas
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(155, 196, 218, 210),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/keranjang',
                          arguments: quantities);
                    },
                    icon: Icon(
                      Icons.shopping_cart_outlined,
                      color: Color(0xFF057350),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: 500,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 3,
                          offset: Offset(0, 4),
                          blurRadius: 7,
                        ),
                      ],
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Cari pesanan',
                        hintStyle: TextStyle(
                          color: Color(0xFFDADADA),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          padding: const EdgeInsets.only(right: 10),
                          icon: Icon(
                            Icons.search_rounded,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/-');
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 15.0,
                  children: [
                    _buildFilterOption('Semua'),
                    _buildFilterOption('Makanan'),
                    _buildFilterOption('Minuman'),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: product
                    .where((p) =>
                        selectedFilter == null ||
                        selectedFilter == 'Semua' ||
                        p['Kategori'] == selectedFilter)
                    .length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 10,
                  childAspectRatio: 4 / 6, // Perbandingan tinggi dan lebar
                ),
                itemBuilder: (context, index) {
                  var filteredProducts = product.where((p) =>
                      selectedFilter == null ||
                      selectedFilter == 'Semua' ||
                      p['Kategori'] == selectedFilter);
                  var item = filteredProducts.elementAt(index);

                  return _buildProductCard(
                    imagePath: item['imagePath']!,
                    productName: item['productName']!,
                    price: item['price']!,
                    Kategori: item['Kategori']!,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterOption(String label) {
    bool isSelected = label == selectedFilter;

    return InkWell(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : Color(0xFFAEAEAE),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4.0),
              height: 2.0,
              width: 50,
              color: Color(0xFF057350),
            ),
        ],
      ),
    );
  }

  Widget _buildProductCard({
    required String imagePath,
    required String productName,
    required String price,
    required String Kategori,
  }) {
    double productPrice = double.parse(price.replaceAll('Rp ', '').replaceAll(',', ''));

    return SizedBox(
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          height: 230,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          price,
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF057350),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove_circle_outline_outlined,
                                  color: Color(0xFF057350)),
                              onPressed: () {
                                setState(() {
                                  if (quantities[productName]! > 0) {
                                    quantities[productName] =
                                        quantities[productName]! - 1;
                                  }
                                  updateQuantity(productName,
                                      quantities[productName]!);
                                });
                              },
                            ),
                            Text(
                              '${quantities[productName]}',
                              style: TextStyle(fontSize: 16),
                            ),
                            IconButton(
                              icon: Icon(Icons.add_circle_outline_outlined,
                                  color: Color(0xFF057350)),
                              onPressed: () {
                                setState(() {
                                  quantities[productName] =
                                      quantities[productName]! + 1;
                                  updateQuantity(productName,
                                      quantities[productName]!);
                                });
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
