import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:mongo_flutter/dbhelper/const.dart';
import 'package:mongo_flutter/mongoModel.dart';

class MongoDatabase {
  static var db, userCollection;

  static connect() async {
    db = await Db.create(MONGO_URL);
    await db.open();
    inspect(db);
    print(db);
    userCollection = db.collection(USER_COLL);
  }

  static Future<String> insert(MongoDBmodel model) async {
    try {
      var result = await userCollection.insertOne(model.toJson());
      if (result.isSuccess) {
        return "Data inserted";
      } else {
        return "Something went wrong";
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  static Future<List<Map<String, dynamic>>> getData() async {
    final data = await userCollection.find().toList();
    return data;
  }

  static Future<String> update(MongoDBmodel model) async {
    var result = await userCollection.findOne({"_id": model.id});
    result['firstName'] = model.firstName;
    result['lastName'] = model.lastName;
    result['address'] = model.address;
    result['imagebase64'] = model.imagebase64;
    var responce = await userCollection.save(result);
    inspect(responce);
    return "Done";
  }

  static Future<String> delete(ObjectId id) async {
    var result = await userCollection.remove(where.id(id));
    return "Deleted";
  }

  static Future<List<Map<String, dynamic>>> querySearch(
      String fname, String lname, String address) async {
    if (fname.isEmpty && lname.isEmpty && address.isEmpty) {
      final data = await userCollection.find().toList();
      return data;
    } else if (fname.isNotEmpty && lname.isEmpty && address.isEmpty) {
      // searching by specific field "firstName".
      final data = await userCollection
          .find(where.match("firstName", fname.toString().toLowerCase()))
          .toList();
      return data;
    } else if (fname.isEmpty && lname.isNotEmpty && address.isEmpty) {
      final data = await userCollection
          .find(where.match("lastName", lname.toString().toLowerCase()))
          .toList();
      return data;
    } else if (fname.isEmpty && lname.isEmpty && address.isNotEmpty) {
      final data = await userCollection
          .find(where.match("address", address.toString().toLowerCase()))
          .toList();
      return data;
    } else if (fname.isNotEmpty && lname.isNotEmpty && address.isEmpty) {
      final data = await userCollection
          .find(where
              .match("firstName", fname.toString().toLowerCase())
              .match("lastName", lname.toString().toLowerCase()))
          .toList();
      return data;
    } else if (fname.isNotEmpty && lname.isEmpty && address.isNotEmpty) {
      final data = await userCollection
          .find(where
              .match("firstName", fname.toString().toLowerCase())
              .match("address", address.toString().toLowerCase()))
          .toList();
      return data;
    } else if (fname.isEmpty && lname.isNotEmpty && address.isNotEmpty) {
      final data = await userCollection
          .find(where
              .match("lastName", lname.toString().toLowerCase())
              .match("address", address.toString().toLowerCase()))
          .toList();
      return data;
    } else {
      final data = await userCollection
          .find(where
              .match("firstName", fname.toString().toLowerCase())
              .match("lastName", lname.toString().toLowerCase())
              .match("address", address.toString().toLowerCase()))
          .toList();
      return data;
    }
  }
}
