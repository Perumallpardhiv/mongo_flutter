import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mongo_flutter/dbhelper/mongodb.dart';
import 'package:mongo_flutter/pages/insert.dart';
import 'package:mongo_flutter/model/mongoModel.dart';

class display extends StatefulWidget {
  const display({super.key});

  @override
  State<display> createState() => _displayState();
}

class _displayState extends State<display> {
  var firstNameSearch = "";
  var lastNameSearch = "";
  var addressSearch = "";
  UniqueKey keyTile = UniqueKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: ExpansionTile(
                    initiallyExpanded: false,
                    key: keyTile,
                    title: const Text(
                      "Search From List",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 8, 7, 7),
                      ),
                    ),
                    childrenPadding: const EdgeInsets.all(12),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(3, 6, 3, 4),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              firstNameSearch = value;
                            });
                          },
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 1, color: Colors.blue),
                                borderRadius: BorderRadius.circular(50)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 3, color: Colors.blue),
                                borderRadius: BorderRadius.circular(50)),
                            prefixIcon: const Icon(
                              Icons.search,
                              size: 25,
                            ),
                            labelText: "Search by FirstName",
                            contentPadding: const EdgeInsets.only(left: 10),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(3, 4, 3, 4),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              lastNameSearch = value;
                            });
                          },
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 1, color: Colors.blue),
                                borderRadius: BorderRadius.circular(50)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 3, color: Colors.blue),
                                borderRadius: BorderRadius.circular(50)),
                            prefixIcon: const Icon(
                              Icons.search,
                              size: 25,
                            ),
                            labelText: "Search by LastName",
                            contentPadding: const EdgeInsets.only(left: 10),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(3, 4, 3, 6),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              addressSearch = value;
                            });
                          },
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 1, color: Colors.blue),
                                borderRadius: BorderRadius.circular(50)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 3, color: Colors.blue),
                                borderRadius: BorderRadius.circular(50)),
                            prefixIcon: const Icon(
                              Icons.search,
                              size: 25,
                            ),
                            labelText: "Search by Address",
                            contentPadding: const EdgeInsets.only(left: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: MongoDatabase.querySearch(
                      firstNameSearch, lastNameSearch, addressSearch),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      if (snapshot.hasData) {
                        var totaldata = snapshot.data.length;
                        print(totaldata.toString());
                        if (totaldata != 0) {
                          return ListView.builder(
                            itemCount: totaldata,
                            itemBuilder: (context, index) {
                              var dataindex =
                                  MongoDBmodel.fromJson(snapshot.data[index]);
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 11.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: Image.memory(
                                              base64Decode(
                                                  dataindex.imagebase64),
                                              fit: BoxFit.cover,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.23,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.1,
                                            ),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(dataindex.id.$oid),
                                            Text(dataindex.firstName),
                                            Text(dataindex.lastName),
                                            Text(dataindex.address),
                                          ],
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    insertorEditData(
                                                  datamodel: dataindex,
                                                ),
                                              ),
                                            );
                                            setState(() {});
                                          },
                                          icon: const Icon(Icons.edit),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            var result =
                                                await MongoDatabase.delete(
                                                    dataindex.id);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(result)));
                                            setState(() {});
                                          },
                                          icon: const Icon(Icons.delete),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return const Center(
                            child: Text("No Data"),
                          );
                        }
                      } else {
                        return const Center(
                          child: Text("No Data"),
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => insertorEditData(),
              ));
          setState(() {});
        },
        label: const Text("Insert Data"),
      ),
    );
  }
}
