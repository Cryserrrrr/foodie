import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> fetchProduct(String? code) async {
  final response = await http.get(
      Uri.parse('https://world.openfoodfacts.org/api/v0/product/$code.json'));

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    return jsonResponse['product'];
  } else {
    throw Exception('Failed to load product');
  }
}
