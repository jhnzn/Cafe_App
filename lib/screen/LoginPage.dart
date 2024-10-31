import 'package:cafe_app/screen/AdminPage.dart';
import 'package:cafe_app/screen/DataTransaksi.dart';
import 'package:cafe_app/screen/OrderPage.dart';
import 'package:cafe_app/screen/model/user_model.dart';
import 'package:cafe_app/screen/service/user_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  String? selectedRole;

  void _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      // Tampilkan pesan kesalahan
      print('Username atau password tidak boleh kosong');
      return;
    }

    UserModel? user = await UserService.login(username, password);

    if (user != null) {
      // Login berhasil, lanjutkan ke halaman sesuai peran
      print('Login berhasil: ${user.Nama}');

      switch (user.Role) {
      case 'Admin':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminPage()), // Ganti dengan halaman Admin
        );
        break;
      case 'Manajer':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DataTransaksi()), // Ganti dengan halaman Manajer
        );
        break;
      case 'Kasir':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OrderPage()), // Ganti dengan halaman Kasir
        );
        break;
      default:
        print('Role tidak dikenali');
    }
  } else {
    // Tampilkan pesan kesalahan
    print('Login gagal, periksa username dan password');
  }
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Text(
                  'Masuk',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                Text(
                  'Username',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(188, 217, 217, 217),
                    hintText: 'Nama Kamu',
                    hintStyle: TextStyle(color: Colors.black, fontSize: 14),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Password',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(188, 217, 217, 217),
                    hintText: 'Kata Sandi',
                    hintStyle: TextStyle(color: Colors.black, fontSize: 14),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF057350),
                      padding:
                          EdgeInsets.symmetric(horizontal: 150, vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    onPressed: _login,
                    child: Text(
                      'Masuk',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
