class MejaModel {
  String nomorMeja; 
  String kapasitas;
  String status;
  String docId;

  MejaModel({
    required this.nomorMeja,
    required this.kapasitas,
    required this.status,
    required this.docId,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'NomorMeja': nomorMeja,
      'Kapasitas': kapasitas,
      'Status': status,
    };
  }

  static MejaModel fromFirestore(Map<String, dynamic> data, String docId) {
    return MejaModel(
      nomorMeja: data['NomorMeja'],
      kapasitas: data['Kapasitas'],
      status: data['Status'] ?? 'Kosong',
      docId: docId,
    );
  }
}
