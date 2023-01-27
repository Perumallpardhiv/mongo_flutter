import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

MongoDBmodel mongoDBmodelFromJson(String str) =>
    MongoDBmodel.fromJson(json.decode(str));

String mongoDBmodelToJson(MongoDBmodel data) => json.encode(data.toJson());

class MongoDBmodel {
  ObjectId id;
  String firstName;
  String lastName;
  String address;

  MongoDBmodel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.address,
  });

  factory MongoDBmodel.fromJson(Map<String, dynamic> json) => MongoDBmodel(
        id: json["_id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "firstName": firstName,
        "lastName": lastName,
        "address": address,
      };
}
