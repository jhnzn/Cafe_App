import 'dart:io';
import 'package:cafe_app/screen/model/produk_model.dart';
import 'package:cafe_app/screen/service/produk_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TambahProduk extends StatefulWidget {
  const TambahProduk({super.key});

  @override
  State<TambahProduk> createState() => _TambahProdukState();
}

class _TambahProdukState extends State<TambahProduk> {
  TextEditingController _NamaProdukController = TextEditingController();
  TextEditingController _PriceController = TextEditingController();
  ProdukService produkService = ProdukService();
  String? selectedKategori;
  File? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Produk',
          style: TextStyle(
              color: Colors.black, fontSize: 19, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 80,
                    height: 78,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9),
                      borderRadius: const BorderRadius.all(Radius.circular(7)),
                    ),
                    child: Center(
                      child: imageUrl == null
                          ? Image.asset(
                              'assets/image.png',
                              width: 36,
                            )
                          : Image.file(
                              imageUrl!,
                              fit: BoxFit.cover,
                              width: 80,
                              height: 78,
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _NamaProdukController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(188, 217, 217, 217),
                    hintText: 'Nama Produk',
                    hintStyle:
                        const TextStyle(color: Colors.black, fontSize: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _PriceController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(188, 217, 217, 217),
                    hintText: 'Harga jual',
                    hintStyle:
                        const TextStyle(color: Colors.black, fontSize: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(188, 217, 217, 217),
                    hintText: 'Pilih Kategori',
                    hintStyle:
                        const TextStyle(color: Colors.black, fontSize: 14),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  value: selectedKategori,
                  items: <String>['Makanan', 'Minuman'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedKategori = newValue;
                    });
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF057350),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 150, vertical: 20),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () async {
                    if (imageUrl == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Silakan pilih gambar terlebih dahulu')),
                      );
                      return;
                    }

                    try {
                      // Unggah gambar ke Firebase Storage
                      String downloadUrl = await _uploadImage(imageUrl!);

                      // Buat objek produk baru
                      ProdukModel newProduk = ProdukModel(
                        NamaProduk: _NamaProdukController.text,
                        Price: int.parse(_PriceController.text),
                        ImageUrl: downloadUrl, // Simpan URL HTTP
                        Kategori: selectedKategori!,
                        docId: '', // Firestore akan memberikan ID dokumen
                      );

                      // Tambahkan produk ke Firestore
                      await produkService.addProduk(newProduk);

                      Navigator.pop(context, true);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Produk berhasil ditambahkan')),
                      );
                    } catch (e) {
                      print("Exception: $e");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Gagal menambah Produk: $e')),
                      );
                    }
                  },
                  child: const Text(
                    'Simpan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
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

  Future<void> _pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          imageUrl = File(pickedFile.path);
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('No image selected')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
    }
  }

  Future<String> _uploadImage(File image) async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('produk_images/${DateTime.now().millisecondsSinceEpoch}');
    final uploadTask = storageRef.putFile(image);
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL(); // Mengembalikan URL HTTP
  }
}
