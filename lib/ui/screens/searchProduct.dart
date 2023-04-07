import 'dart:math';
import 'package:flutter/material.dart';
import 'detailedProduct.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food_projet/repositories/getProducts.dart';
import 'dart:convert';

class SearchProduct extends StatefulWidget {
  final SharedPreferences? prefs;
  const SearchProduct({Key? key, this.prefs}) : super(key: key);
  final bool fetching = false;

  @override
  SearchProductState createState() => SearchProductState();
}

class SearchProductState extends State<SearchProduct> {
  List products = [];
  get history => widget.prefs;
  bool fetching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Project'),
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
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for a product',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              autofocus: true,
              onSubmitted: (value) async {
                setState(() {
                  fetching = true;
                });
                products = await fetchProducts(value);
                setState(() {
                  products = products;
                  fetching = false;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              builder: (context, snapshot) {
                if (fetching) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (products.isNotEmpty) {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                                padding: const EdgeInsets.all(8.0),
                                //center the text
                                child: Text(
                                  products[index]['product_name'],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
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
                return const Center(
                  child: Text('Veuillez entrer un produit à rechercher'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
