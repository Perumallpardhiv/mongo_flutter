import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as Mongo;
import 'package:mongo_flutter/dbhelper/mongodb.dart';
import 'package:mongo_flutter/display.dart';
import 'package:mongo_flutter/mongoModel.dart';

class insertorEditData extends StatefulWidget {
  MongoDBmodel? datamodel;
  insertorEditData({this.datamodel});

  @override
  State<insertorEditData> createState() => _insertorEditDataState();
}

class _insertorEditDataState extends State<insertorEditData> {
  var firstnameCont = TextEditingController();
  var lastnameCont = TextEditingController();
  var addressnameCont = TextEditingController();

  void _fakedata() {
    setState(() {
      firstnameCont.text = faker.person.firstName();
      lastnameCont.text = faker.person.lastName();
      addressnameCont.text =
          faker.address.streetName() + " " + faker.address.streetAddress();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.datamodel != null) {
      firstnameCont.text = widget.datamodel!.firstName;
      lastnameCont.text = widget.datamodel!.lastName;
      addressnameCont.text = widget.datamodel!.address;
    }
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  widget.datamodel != null ? "Update Data" : "Insert Data",
                  style: const TextStyle(fontSize: 22),
                ),
                const SizedBox(
                  height: 50,
                ),
                TextField(
                  controller: firstnameCont,
                  decoration: const InputDecoration(
                    labelText: "FirstName",
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: lastnameCont,
                  decoration: const InputDecoration(
                    labelText: "LastName",
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: addressnameCont,
                  maxLines: 5,
                  minLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Address",
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        _fakedata();
                      },
                      child: const Text("Generating Data"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (widget.datamodel != null) {
                          var id = widget.datamodel!.id;
                          final model = MongoDBmodel(
                            id: id,
                            firstName: firstnameCont.text,
                            lastName: lastnameCont.text,
                            address: addressnameCont.text,
                          );
                          var result = await MongoDatabase.update(model);
                          print(result);
                        } else {
                          var id = Mongo.ObjectId();
                          final model = MongoDBmodel(
                            id: id,
                            firstName: firstnameCont.text.toLowerCase(),
                            lastName: lastnameCont.text.toLowerCase(),
                            address: addressnameCont.text,
                          );
                          var result = await MongoDatabase.insert(model);
                          print(result);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Inserted ID : " + id.$oid)));
                        }
                        Navigator.pop(context, true);
                      },
                      child: widget.datamodel == null
                          ? Text("Insert Data")
                          : Text("Update Data"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
