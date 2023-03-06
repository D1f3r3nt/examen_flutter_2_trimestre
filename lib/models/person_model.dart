import 'package:meta/meta.dart';
import 'dart:convert';

class PersonModel {
  PersonModel({
    this.id,
    this.firebaseID,
    required this.name,
    required this.email,
    required this.address,
    required this.phone,
    required this.photo,
  });

  int? id;
  String? firebaseID;
  String name;
  String email;
  String address;
  String phone;
  String photo;

  factory PersonModel.fromJson(String str) =>
      PersonModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PersonModel.fromMap(Map<String, dynamic> json) => PersonModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        address: json["address"],
        phone: json["phone"],
        photo: json["photo"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "email": email,
        "address": address,
        "phone": phone,
        "photo": photo,
      };
}
