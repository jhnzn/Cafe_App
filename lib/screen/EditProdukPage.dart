import 'package:cafe_app/screen/model/produk_model.dart';
import 'package:cafe_app/screen/service/produk_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProduk extends StatefulWidget {
  final ProdukModel produk;
  final ProdukService firebaseService = ProdukService();

  EditProduk({required this.produk});

  @override
  State<EditProduk> createState() => _EditProdukState();
}

class _EditProdukState extends State<EditProduk> {
  late TextEditingController _NamaProdukController;
  late TextEditingController _PriceController;
  File? _selectedImage;
  String? selectedKategori;
  String? imageUrl; // URL gambar yang diunggah ke Firebase

  @override
  void initState() {
    super.initState();
    _NamaProdukController =
        TextEditingController(text: widget.produk.NamaProduk);
    _PriceController = TextEditingController(text: widget.produk.Price.toString());
    selectedKategori = widget.produk.Kategori;
    imageUrl = widget.produk.ImageUrl; // Menyimpan URL gambar awal
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Produk',
          style: TextStyle(
            color: Colors.black,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: _selectedImage != null
                    ? Image.file(
                        _selectedImage!,
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        widget.produk.ImageUrl,
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _NamaProdukController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(188, 217, 217, 217),
                hintText: 'Nama produk',
                hintStyle: TextStyle(color: Colors.black, fontSize: 14),
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
                fillColor: Color.fromARGB(188, 217, 217, 217),
                hintText: 'Harga jual',
                hintStyle: TextStyle(color: Colors.black, fontSize: 14),
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
                fillColor: Color.fromARGB(188, 217, 217, 217),
                hintText: 'Pilih Kategori',
                hintStyle: TextStyle(color: Colors.black, fontSize: 14),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
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
                backgroundColor: Color(0xFF057350),
                padding:
                    const EdgeInsets.symmetric(horizontal: 210, vertical: 20),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () async {
                if (_selectedImage != null) {
                  imageUrl = await _uploadImage(_selectedImage!);
                }

               final updateProduk = ProdukModel(
  NamaProduk: _NamaProdukController.text,
  Price: int.tryParse(_PriceController.text) ?? 0, // Konversi string ke integer
  Kategori: selectedKategori ?? '',
  ImageUrl: imageUrl ?? widget.produk.ImageUrl,
  docId: widget.produk.docId,
);

                await widget.firebaseService
                    .updateProduk(widget.produk.docId, updateProduk);
                Navigator.pop(context, updateProduk);
              },
              child: Text(
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
    );
  }

  Future<String> _uploadImage(File image) async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('produk_images/${DateTime.now().millisecondsSinceEpoch}');
    final uploadTask = storageRef.putFile(image);
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }
}