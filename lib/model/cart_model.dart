class CartModel {
  final int primaryKey;
  final int id;
  final String categoryName;
  final String? name;
  final int quantity;
  final String? colour;
  final String brandName;
  final String price;
  final String totalPrice;

  final String image;

  CartModel(
      {required this.primaryKey,
      required this.id,
      required this.categoryName,
      this.name,
      required this.quantity,
      this.colour,
      required this.brandName,
      required this.price,
      required this.totalPrice,
      required this.image});

  factory CartModel.fromMap(Map<dynamic, dynamic> map) {
    return CartModel(
        primaryKey: map['primaryKey'],
        id: map['id'],
        categoryName: map['categoryName'],
        name: map['name'],
        quantity: map['quantity'],
        colour: map['colour'],
        brandName: map['brandName'],
        price: map['price'],
        totalPrice: map['totalPrice'],
        image: map['image']);
  }

  Map<String, Object?> toMap() {
    return {
      'primaryKey': primaryKey,
      'id': id,
      'categoryName': categoryName,
      'name': name,
      'quantity': quantity,
      'colour': colour,
      'brandName': brandName,
      'price': price,
      'totalPrice': totalPrice,
      'image': image
    };
  }
}
