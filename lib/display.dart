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
  var word = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      word = value;
                    });
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.blue),
                        borderRadius: BorderRadius.circular(50)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 3, color: Colors.blue),
                        borderRadius: BorderRadius.circular(50)),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 25,
                    ),
                    labelText: "Search by Name",
                    contentPadding: EdgeInsets.only(left: 10),
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: MongoDatabase.querySearch(word),
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
                          itemBuilder: (context, index) {
                            var dataindex =
                                MongoDBmodel.fromJson(snapshot.data[index]);
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
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
                                      icon: Icon(Icons.edit),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        var result = await MongoDatabase.delete(
                                            dataindex.id);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(result)));
                                        setState(() {});
                                      },
                                      icon: Icon(Icons.delete),
                                    ),
                                  ],
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
        label: Text("Insert Data"),
      ),
    );
  }
}
