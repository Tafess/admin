import 'dart:convert';

CustomerModel customerModelFromJson(String str) =>
    CustomerModel.fromJson(json.decode(str));

String customerModelToJson(CustomerModel data) => json.encode(data.toJson());

class CustomerModel {
  String? image;
  String id;
  String name;
  String email;

  CustomerModel({
    this.image,
    required this.id,
    required this.name,
    required this.email,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
        image: json['image'] ?? '',
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        email: json['email'] ?? '',
      );
  Map<String, dynamic> toJson() => {
        'image': image,
        'id': id,
        'name': name,
        'email': email,
      };

  CustomerModel copyWith({
    String? name,
    image,
  }) =>
      CustomerModel(
          id: id,
          name: name ?? this.name,
          image: image ?? this.image,
          email: email);
}
