import 'package:cafe_app/screen/model/meja_model.dart';
import 'package:cafe_app/screen/service/meja_service.dart';
import 'package:flutter/material.dart';

class EditMeja extends StatefulWidget {
  final MejaModel meja;
  final MejaService firebaseService = MejaService();

  EditMeja({required this.meja});

  @override
  State<EditMeja> createState() => _EditMejaState();
}

class _EditMejaState extends State<EditMeja> {
  late TextEditingController _nomorMejaController ;
  late TextEditingController _kapasitasController;
  String? selectedStatus;

  @override
  void initState() {
    super.initState();
    _nomorMejaController =
        TextEditingController(text: widget.meja.nomorMeja);
    _kapasitasController =
        TextEditingController(text: widget.meja.kapasitas);
    selectedStatus =
        widget.meja.status; // Initialize with the current status
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Meja',
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
              controller: _nomorMejaController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(188, 217, 217, 217),
                hintText: 'Nomor Meja',
                hintStyle: TextStyle(color: Colors.black, fontSize: 14),
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
                fillColor: Color.fromARGB(188, 217, 217, 217),
                hintText: 'Kapasitas',
                hintStyle: TextStyle(color: Colors.black, fontSize: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF057350),
                padding: EdgeInsets.symmetric(horizontal: 150, vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
             onPressed: () async {
                final updateMeja = MejaModel(
                  nomorMeja: _nomorMejaController.text,
                  kapasitas: _kapasitasController.text,
                  status: selectedStatus ?? '',
                   docId: widget.meja.docId, 
                );
                await widget.firebaseService
                    .updateMeja(widget.meja.docId, updateMeja);
                Navigator.pop(context, updateMeja);
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
}
