class Product {
  final String? name;
  final String? image;
  final String? code;

  Product(this.name, this.image, this.code);

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      json['product_name'],
      json['image_small_url'],
      json['code'],
    );
  }
}
