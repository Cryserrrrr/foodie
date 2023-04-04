import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailedProduct extends StatefulWidget {
  final String? code;
  const DetailedProduct(this.code, {super.key});

  @override
  _DetailedProductState createState() => _DetailedProductState();
}

class _DetailedProductState extends State<DetailedProduct> {
  bool showNutritionFact = false;
  get code => widget.code;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchProduct(code),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var product = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          product['image_url'] ?? '',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      product['product_name'] ?? 'No product name',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      product['brands'] ?? "No brand",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      product['quantity'] ?? "No quantity",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Nutriscore: ',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          product['nutriscore_grade'].toUpperCase() ??
                              "No nutriscore",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: _getNutriscoreColor(
                                product['nutriscore_grade']),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Icon(
                          product['nutriscore_grade'] == 'a'
                              ? Icons.arrow_circle_up_rounded
                              : product['nutriscore_grade'] == 'b'
                                  ? Icons.arrow_circle_up_rounded
                                  : product['nutriscore_grade'] == 'c'
                                      ? Icons.arrow_circle_down_rounded
                                      : product['nutriscore_grade'] == 'd'
                                          ? Icons.arrow_circle_down_rounded
                                          : product['nutriscore_grade'] == 'e'
                                              ? Icons.arrow_circle_down_rounded
                                              : Icons.info_outline_rounded,
                          color:
                              _getNutriscoreColor(product['nutriscore_grade']),
                          size: 24.0,
                        ),
                      ],
                    ),
                  ),
                  if (showNutritionFact)
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nutrition Facts:',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            'Energy: ${product['nutriments']['energy']}',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          Text(
                            'Fat: ${product['nutriments']['fat']}',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          Text(
                            'Saturated Fat: ${product['nutriments']['saturated-fat']}',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          Text(
                            'Carbohydrates: ${product['nutriments']['carbohydrates']}',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          Text(
                            'Sugars: ${product['nutriments']['sugars']}',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          Text(
                            'Proteins: ${product['nutriments']['proteins']}',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          Text(
                            'Salt: ${product['nutriments']['salt']}',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showNutritionFact = !showNutritionFact;
                        });
                      },
                      child: Text(
                        showNutritionFact ? 'Hide Details' : 'More Details',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Failed to load product',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

Color _getNutriscoreColor(String? nutriscore) {
  switch (nutriscore) {
    case 'a':
      return Colors.green;
    case 'b':
      return Colors.lightGreen;
    case 'c':
      return Colors.yellow;
    case 'd':
      return Colors.orange;
    case 'e':
      return Colors.red;
    default:
      return Colors.black;
  }
}

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
