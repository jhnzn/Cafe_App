import 'package:cafe_app/screen/EditProdukPage.dart';
import 'package:cafe_app/screen/model/produk_model.dart';
import 'package:cafe_app/screen/service/produk_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataProduct extends StatefulWidget {
  const DataProduct({super.key});

  @override
  State<DataProduct> createState() => _DataProductState();
}

class _DataProductState extends State<DataProduct> {
  String selectedFilter = 'Semua';
  final ProdukService firebaseService = ProdukService();
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kelola Data Produk',
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
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              _buildSearchField(),
              const SizedBox(height: 10),
              _buildFilterOptions(),
              const SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('Produk').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final produkDocs = snapshot.data!.docs;
                  final filteredProduk = produkDocs.where((produDoc) {
                    final data = produDoc.data() as Map<String, dynamic>;
                    final kategori = data['Kategori'];
                    final namaProduk = data['NamaProduk'].toString().toLowerCase();
                    return (selectedFilter == 'Semua' || kategori == selectedFilter) &&
                           (searchQuery.isEmpty || namaProduk.contains(searchQuery.toLowerCase()));
                  }).toList();

                  return Wrap(
                    spacing: 30,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: filteredProduk.map((userDoc) {
                      final data = userDoc.data() as Map<String, dynamic>;
                      return _buildProductCard(
                        imageUrl: data['ImageUrl'] ?? '',
                        namaProduk: data['NamaProduk'] ?? 'Tanpa Nama',
                        price: int.tryParse(data['Price'].toString()) ?? 0,
                        kategori: data['Kategori'] ?? 'Kategori tidak tersedia',
                        docId: userDoc.id,
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildAddProductButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Center(
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
                offset: const Offset(0, 4),
                blurRadius: 7,
              ),
            ],
          ),
          child: TextFormField(
            onChanged: (value) {
              setState(() {
                searchQuery = value; // Memperbarui query pencarian
              });
            },
            decoration: InputDecoration(
              hintText: 'Cari Produk',
              hintStyle: TextStyle(
                color: Color(0xFFDADADA),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                padding: const EdgeInsets.only(right: 10),
                icon: const Icon(
                  Icons.search_rounded,
                  color: Colors.black,
                ),
                onPressed: () {
                  // Implementasikan logika pencarian di sini
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterOptions() {
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 15.0,
      children: [
        _buildFilterOption('Semua'),
        _buildFilterOption('Minuman'),
        _buildFilterOption('Makanan'),
      ],
    );
  }

  Widget _buildAddProductButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF057350),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          onPressed: () async {
            final result = await Navigator.pushNamed(context, '/TambahProduk');
            if (result == true) {
              setState(() {}); // Memperbarui tampilan setelah menambahkan produk
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_rounded, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Tambah Produk',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
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
              color: const Color(0xFF057350),
            ),
        ],
      ),
    );
  }

  Widget _buildProductCard({
    required String imageUrl,
    required String namaProduk,
    required int price,
    required String kategori,
    required String docId,
  }) {
    return InkWell(
      // Tambahkan logika untuk navigasi ke detail produk jika diperlukan
      child: SizedBox(
        height: 80,
        width: double.infinity,
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: 70,
                        height: 70,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.error, size: 70);
                        },
                      )
                    : Image.asset(
                        'assets/.png',
                        width: 70,
                        height: 70,
                      ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      namaProduk,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Rp $price',
                      style: const TextStyle(
                        color: Color(0xFF818181),
                        fontSize: 12,
                      ),
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