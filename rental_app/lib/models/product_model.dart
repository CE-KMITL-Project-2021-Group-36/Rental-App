class Product {
  final int id;
  final String name;
  final String price;
  final String imageUrl;

  Product({required this.id,required this.name, required this.price, required this.imageUrl});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'imageUrl': imageUrl,
  };
}