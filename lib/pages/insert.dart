import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mongo_dart/mongo_dart.dart' as Mongo;
import 'package:mongo_flutter/dbhelper/mongodb.dart';
import 'package:mongo_flutter/model/mongoModel.dart';
import 'package:mongo_flutter/provider/provider.dart';
import 'package:provider/provider.dart';

// ignore: camel_case_types, must_be_immutable
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

  Timer? _timer;
  @override
  void initState() {
    super.initState();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    // EasyLoading.showSuccess('Use in initState');
  }

  Uint8List? imgUnit8List;
  String? _base64Img;

  void _fakedata() {
    setState(() {
      firstnameCont.text = faker.person.firstName();
      lastnameCont.text = faker.person.lastName();
      addressnameCont.text =
          "${faker.address.streetName()} ${faker.address.streetAddress()}";
    });
  }

  imageBase64String prov1 = imageBase64String();

  @override
  Widget build(BuildContext context) {
    prov1 = Provider.of<imageBase64String>(context);
    if (widget.datamodel != null) {
      firstnameCont.text = widget.datamodel!.firstName;
      lastnameCont.text = widget.datamodel!.lastName;
      addressnameCont.text = widget.datamodel!.address;
      _base64Img = widget.datamodel!.imagebase64;
      imgUnit8List = base64Decode(_base64Img!);
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
                Consumer<imageBase64String>(
                  builder: (BuildContext context, value, Widget? child) {
                    return GestureDetector(
                      onTap: () {
                        prov1.pickImageBase64();
                      },
                      child: Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 7,
                              color: Colors.black.withOpacity(0.1),
                              offset: const Offset(0, 10),
                            ),
                          ],
                          shape: BoxShape.circle,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: widget.datamodel == null
                              ? const Placeholder(
                                  fallbackHeight: 200,
                                )
                              : Image.memory(
                                  value.imgUnit8List == null
                                      ? imgUnit8List!
                                      : value.imgUnit8List!,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    );
                  },
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
                    Consumer<imageBase64String>(
                      builder: (BuildContext context, value, Widget? child) {
                        return ElevatedButton(
                          onPressed: () async {
                            if (widget.datamodel != null) {
                              var id = widget.datamodel!.id;
                              final model = MongoDBmodel(
                                id: id,
                                firstName: firstnameCont.text.toLowerCase(),
                                lastName: lastnameCont.text.toLowerCase(),
                                address: addressnameCont.text.toLowerCase(),
                                imagebase64: value.base64Img!,
                              );
                              EasyLoading.show(status: 'Updating...');
                              var result = await MongoDatabase.update(model)
                                  .whenComplete(
                                () => EasyLoading.showSuccess(
                                    "Successfully Updated"),
                              );
                              prov1.maketonull();
                              print(result);
                            } else {
                              var id = Mongo.ObjectId();
                              final model = MongoDBmodel(
                                id: id,
                                firstName: firstnameCont.text.toLowerCase(),
                                lastName: lastnameCont.text.toLowerCase(),
                                address: addressnameCont.text.toLowerCase(),
                                imagebase64: value.base64Img!,
                              );
                              EasyLoading.show(status: 'Inserting...');
                              var result = await MongoDatabase.insert(model)
                                  .whenComplete(
                                () => EasyLoading.showSuccess(
                                    'Successfully Inserted!'),
                              );
                              prov1.maketonull();
                              print(result);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Inserted ID : ${id.$oid}"),
                                ),
                              );
                            }
                            Navigator.pop(context, true);
                            EasyLoading.dismiss();
                          },
                          child: widget.datamodel == null
                              ? const Text("Insert Data")
                              : const Text("Update Data"),
                        );
                      },
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
