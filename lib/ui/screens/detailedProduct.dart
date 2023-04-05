import 'package:flutter/material.dart';
import 'package:food_projet/repositories/getProductByCode.dart';

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
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchProduct(code),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var product = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Stack(
                    children: [
                      Container(
                        height: 400,
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
                      Positioned(
                        top: 16,
                        left: 16,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          iconSize: 40,
                          color: Colors.red,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      product['product_name'] ?? 'Ce produit n\'a pas de nom',
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      product['brands'] ?? "Ce produit n'a pas de marque",
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      product['quantity'] ?? "Ce produit n'a pas de quantité",
                      style: const TextStyle(
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
                        const Text(
                          'Nutriscore: ',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          product['nutriscore_grade']
                              ? product['nutriscore_grade'].toUpperCase()
                              : "Ce produit n'a pas de nutriscore",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: _getNutriscoreColor(
                                product['nutriscore_grade']),
                          ),
                        ),
                        const SizedBox(width: 10.0),
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
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Plus de détails:',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            'Energie: ${product['nutriments']['energy']}',
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          Text(
                            'Graisse: ${product['nutriments']['fat']}',
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          Text(
                            'Graisse Saturé: ${product['nutriments']['saturated-fat']}',
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          Text(
                            'Glucides: ${product['nutriments']['carbohydrates']}',
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          Text(
                            'Sucres: ${product['nutriments']['sugars']}',
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          Text(
                            'Proteines: ${product['nutriments']['proteins']}',
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          Text(
                            'Sel: ${product['nutriments']['salt']}',
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          showNutritionFact = !showNutritionFact;
                        });
                      },
                      child: Text(
                        showNutritionFact ? 'Hide Details' : 'More Details',
                        style: const TextStyle(
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
