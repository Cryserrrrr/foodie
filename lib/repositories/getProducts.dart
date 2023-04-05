import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product.dart';

Future<dynamic> fetchProducts(name) async {
  final response = await http.get(Uri.parse(
      'https://fr.openfoodfacts.org/cgi/search.pl?search_terms=$name&search_simple=1&action=process&json=1&page_size=20&fields=product_name,image_small_url,code'));
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body)['products'];
    //if product name is empty, remove it from the list
    jsonResponse
        .map((product) => Product(product['product_name'],
            product['image_small_url'], product['code']))
        .toList();
    jsonResponse.removeWhere((element) =>
        element['product_name'] == '' || element['product_name'] == null);
    jsonResponse.removeWhere((element) =>
        element['image_small_url'] == '' || element['image_small_url'] == null);
    return jsonResponse;
  } else {
    throw Exception('Failed to load products');
  }
}
