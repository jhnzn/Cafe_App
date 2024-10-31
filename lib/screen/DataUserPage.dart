import 'package:cafe_app/screen/EditUserPage.dart';
import 'package:cafe_app/screen/model/user_model.dart';
import 'package:cafe_app/screen/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataUser extends StatefulWidget {
  const DataUser({super.key});

  @override
  State<DataUser> createState() => _DataUserState();
}

class _DataUserState extends State<DataUser> {
  String selectedFilter = 'Semua';
  final UserService firebaseService = UserService(); // Inisialisasi UserService

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kelola Data User',
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
                          offset: const Offset(0, 4),
                          blurRadius: 7,
                        ),
                      ],
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Cari User',
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
                            // Tambahkan fungsi pencarian jika diperlukan
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                alignment: WrapAlignment.start,
                spacing: 15.0,
                children: [
                  _buildFilterOption('Semua'),
                  _buildFilterOption('Manajer'),
                  _buildFilterOption('Kasir'),
                  _buildFilterOption('Admin'),
                ],
              ),
              const SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('User').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('Tidak ada data user'));
                  }

                  final userDocs = snapshot.data!.docs;
                  final filteredUsers = userDocs
                      .where((userDoc) =>
                          selectedFilter == 'Semua' ||
                          userDoc['Role'] == selectedFilter)
                      .toList();

                  return Wrap(
                    spacing: 30,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: filteredUsers.map((userDoc) {
                      final data = userDoc.data() as Map<String, dynamic>;
                      return _buildUserCard(
                        Nama: data['Nama'] ?? 'Tanpa Nama',
                        Role: data['Role'] ?? 'Tidak diketahui',
                        Password: data['Password'] ?? 'Tidak diketahui',
                        docId: userDoc.id,
                      );
                    }).toList(),
                  );
                },
              ),

              const SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF057350),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () async {
                      final result =
                          await Navigator.pushNamed(context, '/TambahUser');
                      if (result == true) {
                        setState(
                            () {}); // Memperbarui tampilan setelah menambahkan user
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add_rounded, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Tambah User',
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

  Widget _buildUserCard({
    required String Nama,
    required String Role,
    required String Password,
    required String docId,
  }) {
    return InkWell(
    onTap: () async {
  final updatedUserData = await Navigator.push<UserModel>(
    context,
    MaterialPageRoute(
      builder: (context) => EditUser(
        user: UserModel(
          Nama: Nama,
          Role: Role,
          Password: Password,
          docId: docId,
        ),
      ),
    ),
  );

  // Cek jika updatedUserData tidak null
  if (updatedUserData != null) {
    // Lakukan sesuatu dengan updatedUserData, misalnya memperbarui tampilan
    print("User diperbarui: ${updatedUserData.Nama}, ${updatedUserData.Role}");
  }

        if (updatedUserData != null) {
          final updatedUser = UserModel(
            Nama: updatedUserData.Nama,
            Password: updatedUserData.Password,
            Role: updatedUserData.Role,
            docId: updatedUserData.docId,
          );

          await UserService().updateUser(docId, updatedUser);
          setState(() {}); // Perbarui tampilan setelah memperbarui pengguna
        }
      },
child: Dismissible(
      key: Key(docId), // Gunakan docId sebagai key untuk Dismissible
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Color(0xFF057350),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) async {
        try {
          await UserService().deleteUser(docId); // Panggil deleteUser dari UserService
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$Nama dihapus')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menghapus user: $e')),
          );
        }
      },
        child: SizedBox(
          height: 80,
          width: double.infinity,
          child: Card(
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: Container(
              height: 63,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Nama,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              Role,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF057350)),
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
        ),
      ),
    );
  }
}
