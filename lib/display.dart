import 'package:flutter/material.dart';
import 'package:mongo_flutter/dbhelper/mongodb.dart';
import 'package:mongo_flutter/insert.dart';
import 'package:mongo_flutter/mongoModel.dart';

class display extends StatefulWidget {
  const display({super.key});

  @override
  State<display> createState() => _displayState();
}

class _displayState extends State<display> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: FutureBuilder(
            future: MongoDatabase.getData(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.hasData) {
                  var totaldata = snapshot.data.length;
                  print(totaldata.toString());
                  return ListView.builder(
                      itemCount: totaldata,
                      itemBuilder: ((context, index) {
                        var dataindex =
                            MongoDBmodel.fromJson(snapshot.data[index]);
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                Text(dataindex.id.$oid),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(dataindex.firstName),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(dataindex.lastName),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(dataindex.address),
                              ],
                            ),
                          ),
                        );
                      }));
                } else {
                  return Center(
                    child: Text("No Data"),
                  );
                }
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => insertData()));
        },
        label: Text("Insert Page"),
      ),
    );
  }
}
