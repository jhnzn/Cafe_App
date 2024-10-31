import 'package:flutter/material.dart';
import 'package:cafe_app/screen/model/user_model.dart';

class EditUser extends StatefulWidget {
  final UserModel user;

  const EditUser({Key? key, required this.user}) : super(key: key);

  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  late TextEditingController _namaController;
  late TextEditingController _passwordController;
    bool _isPasswordVisible = false;
  String? selectedRole;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.user.Nama);
    _passwordController = TextEditingController(text: widget.user.Password);
    selectedRole = widget.user.Role;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kelola data User',
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
            const SizedBox(height: 20),
            TextFormField(
              controller: _namaController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(188, 217, 217, 217),
                hintText: 'Nama User',
                  hintStyle: TextStyle(color: Colors.black, fontSize: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                  borderSide: BorderSide.none,
                ),
                ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              obscureText:!_isPasswordVisible,
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
                      _isPasswordVisible =
                          !_isPasswordVisible; // Toggle visibility
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
              hint: Text('Pilih Role'),
              items: ['Manajer', 'Admin', 'Kasir'].map((String role) {
                return DropdownMenuItem<String>(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedRole = newValue;
                });
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF057350),
                padding:
                    const EdgeInsets.symmetric(horizontal: 150, vertical: 20),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                final updatedUser = UserModel(
                  Nama: _namaController.text,
                  Role: selectedRole!,
                  Password: _passwordController.text,
                  docId: widget.user.docId,
                );
                Navigator.pop(context, updatedUser);
              },
              child: Text('Simpan',
               style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,),
              )
            ),
          ],
        ),
      ),
    );
  }
}
