import 'dart:convert';
import 'package:http/http.dart' as http;

class Products {
  int? id;
  String? title;
  int? price;
  String? description;
  List<String>? images;

  Products({this.id, this.title, this.price, this.description, this.images});

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      id: json['id'],
      title: json['title'],
      price: json['price'],
      description: json['description'],
      images: (json['images'] as List<dynamic>).map((e) => e.toString()).toList(),
    );
  }
}



Future<List<Products>> fetchProducts(int page, int limit) async {
  final response = await http.get(Uri.parse('https://api.escuelajs.co/api/v1/products?offset=${(page - 1) * limit}&limit=$limit'));

  if (response.statusCode == 200) {
    List<dynamic> productJson = jsonDecode(response.body);
    return productJson.map((json) => Products.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load products');
  }
}
