import 'dart:convert';

import 'package:flutter/material.dart';
import 'searchProduct.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'detailedProduct.dart';

Future instance() async {
  return await SharedPreferences.getInstance();
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foodie'),
        centerTitle: true,
        backgroundColor: Colors.red[600],
      ),
      body: FutureBuilder(
        future: instance(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List prefs = snapshot.data.getStringList('historyList') ??
                [
                  {"product_name": "No history yet"}
                ];
            return Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search for a food item',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onTap: () async {
                      bool result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SearchProduct(prefs: snapshot.data),
                        ),
                      );
                      if (result) {
                        setState(() {});
                      }
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    children: <Widget>[
                      const Text(
                        'Search history',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      for (int i = 0; i < prefs.length; i++)
                        TextButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            side: MaterialStateProperty.all(
                              const BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            ),
                          ),
                          onPressed: () async {
                            if (json.decode(prefs[i])['product_name'] ==
                                "No history yet") {
                              return;
                            }
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailedProduct(
                                  int.parse(json.decode(prefs[i])['code'])
                                      .toString(),
                                ),
                              ),
                            );
                            var temp = prefs[i];
                            prefs.removeAt(i);
                            prefs.insert(0, temp.toString());
                            snapshot.data.setStringList('historyList', prefs);
                            setState(() {});
                          },
                          child: Text(
                            json.decode(prefs[i])['product_name'],
                            style: const TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Text("Loading...");
          }
        },
      ),
    );
  }
}
