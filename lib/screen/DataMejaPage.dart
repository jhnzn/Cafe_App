import 'package:cafe_app/screen/EditMejaPage.dart';
import 'package:cafe_app/screen/model/meja_model.dart';
import 'package:cafe_app/screen/service/meja_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataMeja extends StatefulWidget {
  const DataMeja({super.key});

  @override
  State<DataMeja> createState() => _DataMejaState();
}

class _DataMejaState extends State<DataMeja> {
  final MejaService mejaService = MejaService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kelola Data Meja',
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
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('Meja').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('Tidak ada data meja'));
                  }

                  final mejaDocs = snapshot.data!.docs;

                  return Wrap(
                    spacing: 30,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: mejaDocs.map((mejaDoc) {
                      final data = mejaDoc.data() as Map<String, dynamic>;
                      return _buildMejaCard(
                        Nomormeja: data['NomorMeja'] ?? 'Tidak diketahui',
                        kapasitas: data['Kapasitas'] ?? 'Tidak diketahui',
                        Status: data['Status'] ??'Kosong',
                        docId: mejaDoc.id,
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
                      backgroundColor: const Color(0xFF057350),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () async {
                      final result = await Navigator.pushNamed(context, '/TambahMeja'); // Ensure this is correct
                      if (result == true) {
                        setState(() {}); // Refresh the data display
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.add_rounded, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Tambah Meja',
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

  Widget _buildMejaCard({
    required String Nomormeja,
    required String kapasitas,
    required String Status,
    required String docId,
  }) {
    return InkWell(
      onTap: () async {
        final updatedMejaData = await Navigator.push<MejaModel>(
          context,
          MaterialPageRoute(
            builder: (context) => EditMeja(
              meja: MejaModel(
                nomorMeja: Nomormeja,
                kapasitas: kapasitas,
                status: Status,
                docId: docId,
              ),
            ),
          ),
        );

        if (updatedMejaData != null) {
          await mejaService.updateMeja(docId, updatedMejaData);
          setState(() {}); // Refresh the data display
        }
      },
      child: Dismissible(
        key: Key(docId),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          color: const Color(0xFF057350),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        onDismissed: (direction) async {
          try {
            await mejaService.deleteMeja(docId);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$Nomormeja dihapus')),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Gagal menghapus meja: $e')),
            );
          }
        },
        child: SizedBox(
          height: 80,
          width: double.infinity,
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      Nomormeja,
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
                            kapasitas,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                           Text(
                            Status,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4CD964),
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
      ),
    );
  }
}
