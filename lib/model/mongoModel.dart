import 'package:mongo_dart/mongo_dart.dart';

class MongoDBmodel {
  ObjectId id;
  String firstName;
  String lastName;
  String address;
  String imagebase64;

  MongoDBmodel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.imagebase64,
  });

  factory MongoDBmodel.fromJson(Map<String, dynamic> json) => MongoDBmodel(
      id: json["_id"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      address: json["address"],
      imagebase64: json["imagebase64"]);

  Map<String, dynamic> toJson() => {
        "_id": id,
        "firstName": firstName,
        "lastName": lastName,
        "address": address,
        "imagebase64": imagebase64,
      };
}
