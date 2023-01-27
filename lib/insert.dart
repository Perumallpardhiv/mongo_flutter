import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as Mongo;
import 'package:mongo_flutter/dbhelper/mongodb.dart';
import 'package:mongo_flutter/display.dart';
import 'package:mongo_flutter/mongoModel.dart';

class insertData extends StatefulWidget {
  const insertData({super.key});

  @override
  State<insertData> createState() => _insertDataState();
}

class _insertDataState extends State<insertData> {
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

  Future<void> insert(String fname, String lname, String address) async {
    var id = Mongo.ObjectId();
    final model = MongoDBmodel(
        id: id, firstName: fname, lastName: lname, address: address);
    var result = await MongoDatabase.insert(model);
    print(result);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Inserted ID : " + id.$oid)));
    clearall();
  }

  void clearall() {
    firstnameCont.text = "";
    lastnameCont.text = "";
    addressnameCont.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text(
                "Insert Data",
                style: TextStyle(fontSize: 22),
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
                    onPressed: () {
                      insert(firstnameCont.text, lastnameCont.text,
                          addressnameCont.text);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => display()));
                    },
                    child: const Text("Insert Data"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
