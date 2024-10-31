import 'package:cafe_app/screen/model/meja_model.dart';
import 'package:cafe_app/screen/service/meja_service.dart';
import 'package:flutter/material.dart';

class TambahMeja extends StatefulWidget {
  const TambahMeja({super.key});

  @override
  State<TambahMeja> createState() => _TambahMejaState();
}

class _TambahMejaState extends State<TambahMeja> {
  final TextEditingController _nomorMejaController = TextEditingController();
  final TextEditingController _kapasitasController = TextEditingController();
  final MejaService mejaService = MejaService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Meja',
          style: TextStyle(
            color: Colors.black,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
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
                TextFormField(
                  controller: _nomorMejaController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(188, 217, 217, 217),
                    hintText: 'No Meja',
                    hintStyle: const TextStyle(color: Colors.black, fontSize: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _kapasitasController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(188, 217, 217, 217),
                    hintText: 'Kapasitas',
                    hintStyle: const TextStyle(color: Colors.black, fontSize: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF057350),
                    padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 20),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      MejaModel newMeja = MejaModel(
                        nomorMeja: _nomorMejaController.text,
                        kapasitas: _kapasitasController.text,
                        status: 'Kosong', // Default status
                        docId: '',
                      );

                      await mejaService.addMeja(newMeja);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Berhasil menambahkan meja")),
                      );

                      Navigator.pop(context, true); // Pass true back to the previous screen
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Gagal menambahkan meja")),
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
}
