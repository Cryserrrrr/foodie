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
            return Column(children: <Widget>[
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
              const SizedBox(height: 20),
              Text('History',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[600]),
                  textAlign: TextAlign.center),
              const SizedBox(height: 20),
              Expanded(
                  child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: ListView.separated(
                          itemBuilder: (context, index) {
                            ;
                            return Card(
                                margin: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.05),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: ListTile(
                                    onTap: () {
                                      if (json.decode(
                                              prefs[index])['product_name'] ==
                                          "No history yet") {
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DetailedProduct(
                                              int.parse(json.decode(
                                                      prefs[index])['code'])
                                                  .toString(),
                                            ),
                                          ),
                                        );
                                        String temp = prefs[index];
                                        prefs.removeAt(index);
                                        prefs.insert(0, temp.toString());
                                        snapshot.data.setStringList(
                                            'historyList', prefs);
                                        setState(() {});
                                      }
                                    },
                                    title: Center(
                                        child: Text(json.decode(
                                            prefs[index])['product_name']))));
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 12,
                            );
                          },
                          itemCount: prefs.length > 10 ? prefs.length : 10))),
            ]);
          } else {
            return const Text("Loading...");
          }
        },
      ),
    );
  }
}
