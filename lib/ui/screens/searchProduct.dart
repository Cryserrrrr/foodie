import 'dart:math';

import 'package:flutter/material.dart';
import 'detailedProduct.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchProduct extends StatefulWidget {
  final SharedPreferences? prefs;
  const SearchProduct({Key? key, this.prefs}) : super(key: key);

  @override
  SearchProductState createState() => SearchProductState();
}

// Request open food facts API to get products with the name in the search bar
//Request is limited at 20 products and return only name and image and code of the product
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

class SearchProductState extends State<SearchProduct> {
  List products = [];
  get history => widget.prefs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Project'),
        centerTitle: true,
        backgroundColor: Colors.red[600],
        leading: IconButton(
          onPressed: (() {
            Navigator.pop(context, true);
          }),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for a product',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              autofocus: true,
              onSubmitted: (value) async {
                products = await fetchProducts(value);
                setState(() {
                  products = products;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: fetchProducts(''),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailedProduct(products[index]['code']),
                              ),
                            );
                            List<String> list = [];
                            if (history.getStringList('historyList') == null) {
                              list.add(jsonEncode(products[index]));
                            } else {
                              list.addAll(history.getStringList('historyList'));
                              list.add(jsonEncode(products[index]));
                            }
                            history.setStringList('historyList', list);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Image.network(
                                  products[index]['image_small_url'],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/noImage.png',
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                //center the text
                                child: Text(
                                  products[index]['product_name'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }
}
