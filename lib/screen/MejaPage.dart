import 'package:cafe_app/screen/EditMejaPage.dart';
import 'package:cafe_app/screen/NotaPage.dart';
import 'package:cafe_app/screen/model/meja_model.dart';
import 'package:cafe_app/screen/service/meja_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Mejapage extends StatefulWidget {
  const Mejapage({super.key});

  @override
  State<Mejapage> createState() => _MejapageState();
}

class _MejapageState extends State<Mejapage> {
  final MejaService mejaService = MejaService();
  String selectedFilter = 'Semua';
  String? selectedMeja;
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Meja'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              _buildSearchBar(),
              const SizedBox(height: 10),
              _buildFilterOptions(),
              const SizedBox(height: 20),
              _buildMejaList(),
              const SizedBox(height: 10),
              _buildSelectButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
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
              searchQuery = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Cari Meja',
            hintStyle: const TextStyle(
              color: Color(0xFFDADADA),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              padding: const EdgeInsets.only(right: 10),
              icon: const Icon(Icons.search_rounded, color: Colors.black),
              onPressed: () {
                // Implement search functionality here if needed
              },
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
        _buildFilterOption('Kosong'),
        _buildFilterOption('Digunakan'),
      ],
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
              color: isSelected ? Colors.black : const Color(0xFFAEAEAE),
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

  Widget _buildMejaList() {
    return StreamBuilder<List<MejaModel>>(
      stream: mejaService.getAllMeja(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Tidak ada meja tersedia.'));
        }

        final mejaList = snapshot.data!.where((meja) {
          final matchesFilter = selectedFilter == 'Semua' ||
              (selectedFilter == 'Kosong' && meja.status == 'Kosong') ||
              (selectedFilter == 'Digunakan' && meja.status == 'Digunakan');

          final matchesSearch = meja.nomorMeja.contains(searchQuery);

          return matchesFilter && matchesSearch;
        }).toList();

        return Wrap(
          spacing: 30,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: mejaList.map((meja) => _buildMejaCard(meja)).toList(),
        );
      },
    );
  }

  Widget _buildMejaCard(MejaModel meja) {
    bool isSelected = selectedMeja == meja.nomorMeja;
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedMeja = null; // Jika meja sudah dipilih, batalkan pilihan
          } else {
            selectedMeja = meja.nomorMeja; // Pilih meja ini
          }
        });
      },
      child: SizedBox(
        height: 80,
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: Container(
            height: 63,
            decoration: BoxDecoration(
              color: isSelected ? Colors.green[100] : Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    meja.nomorMeja,
                    style: const TextStyle(
                      fontSize: 39,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kapasitas: ${meja.kapasitas}',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(
                        isSelected ? 'Digunakan' : 'Kosong', // Ubah status di sini
                        style: TextStyle(
                          fontSize: 16,
                          color: isSelected ? const Color(0xFFC90000) : const Color(0xFF4CD964),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF057350),
        padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 20),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: () {
        if (selectedMeja != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Nota(nomormeja: selectedMeja!, quantities: {}),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Silakan pilih meja terlebih dahulu!')),
          );
        }
      },
      child: const Text(
        'Pilih',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
