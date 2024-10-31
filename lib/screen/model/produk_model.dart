class ProdukModel {
  String NamaProduk;
  int Price;
  String Kategori;
  String ImageUrl;
  String docId;

  ProdukModel({
    required this.NamaProduk,
    required this.Price,
    required this.Kategori,
    required this.ImageUrl,
    required this.docId,
  });
  
  // Converting Firestore data to ProdukModel object
  factory ProdukModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return ProdukModel(
      NamaProduk: data['NamaProduk'] ?? '',
      Price: data['Price'] ?? '',
      Kategori: data['Kategori'] ?? '',
      ImageUrl: data['imageUrl'] ?? '',
      docId: docId,
    );
  }

  // Converting ProdukModel object to Firestore format
  Map<String, dynamic> toFirestore() {
    return {
      'NamaProduk': NamaProduk,
      'Price': Price,
      'Kategori': Kategori,
      'imageUrl': ImageUrl,
    };
  }
}
