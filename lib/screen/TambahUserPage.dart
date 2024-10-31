import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cafe_app/screen/model/user_model.dart'; // Pastikan untuk mengimpor UserModel
import 'package:cafe_app/screen/service/user_service.dart'; // Impor UserService

class TambahUser extends StatefulWidget {
  const TambahUser({super.key});

  @override
  State<TambahUser> createState() =>
      _TambahUserState(); // Ubah nama state class
}

class _TambahUserState extends State<TambahUser> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController(); // Deklarasi untuk Password
  String? selectedRole;
  bool _isPasswordVisible = false;
  final UserService userService = UserService(); // Buat instance UserService

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah User',
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
                SizedBox(height: 30),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _namaController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(188, 217, 217, 217),
                    hintText: 'Nama user',
                    hintStyle: TextStyle(color: Colors.black, fontSize: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController, // Tambahkan controller untuk password
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(188, 217, 217, 217),
                    hintText: 'Kata sandi user',
                    hintStyle: TextStyle(color: Colors.black, fontSize: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      padding: const EdgeInsets.only(right: 10),
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(188, 217, 217, 217),
                    hintText: 'Pilih Role',
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
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  value: selectedRole,
                  items:
                      <String>['Manajer', 'Admin', 'Kasir'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedRole = newValue;
                    });
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF057350),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 150, vertical: 20),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      UserModel newUser = UserModel(
                        Nama: _namaController.text,
                        Role: selectedRole!,
                        Password: _passwordController.text, // Menyertakan Password
                        docId: '', // Kosongkan jika tidak dibutuhkan
                      );

                      // Tambah user ke Firestore
                      await userService.addUser(newUser);

                      // Debugging: Cek apakah data berhasil ditambahkan
                      print("User ditambahkan: ${newUser.Nama}, ${newUser.Role}");

                      // Navigasi kembali ke halaman sebelumnya
                      Navigator.pop(context, true); // Mengembalikan nilai true
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('User berhasil ditambahkan')),
                      );
                    } catch (e) {
                      print("Exception: $e");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Gagal menambah user: $e')),
                      );
                    }
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
        ),
      ),
    );
  }
}
