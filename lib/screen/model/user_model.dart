class UserModel {
  String Nama;
  String Role;
  String? docId; // Menyimpan ID dokumen Firestore
  String Password; // Menambahkan field password

  UserModel({
    required this.Nama,
    required this.Role,
    required this.Password,
    this.docId,
  });

  // Method untuk mengkonversi dari Firestore ke UserModel
  factory UserModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return UserModel(
      Nama: data['Nama'] ?? '',
      Role: data['Role'] ?? '',
      Password: data['Password'] ?? '', // Ambil password dari Firestore
      docId: docId,
    );
  }

  // Method untuk mengkonversi UserModel ke format yang bisa disimpan di Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'Nama': Nama,
      'Role': Role,
      'Password': Password, // Menyimpan password di Firestore
    };
  }
}
