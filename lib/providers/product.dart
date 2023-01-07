class Product {
  String name;
  double price;
  int quantity = 1;
  int availableQuantity;
  List<dynamic> imageUrls;
  String documentId;
  String suppId;

  Product(
      {required this.name,
      required this.price,
      required this.quantity,
      required this.availableQuantity,
      required this.imageUrls,
      required this.documentId,
      required this.suppId});

  void increase() => quantity++;

  void decrease() => quantity--;
}
