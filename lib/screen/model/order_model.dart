class OrderModel {
  final String productName;
  final int quantity;
  final int price;

  OrderModel({
    required this.productName,
    required this.quantity,
    required this.price,
  });

  int get totalPrice => quantity * price;

  factory OrderModel.fromFirestore(Map<String, dynamic> data) {
    return OrderModel(
      productName: data['productName'] ?? '',
      quantity: data['quantity'] ?? 0,
      price: data['price'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'productName': productName,
      'quantity': quantity,
      'price': price,
    };
  }

  
}
