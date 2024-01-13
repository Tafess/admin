import 'dart:convert';

AdminModel adminModelFromJson(String str) =>
    AdminModel.fromJson(json.decode(str));

String adminModelToJson(AdminModel data) => json.encode(data.toJson());

class AdminModel {
  String? id;
  String? firstName;
  String? middleName;
  String? lastName;
  String? profileImage;
  String? email;
  String? phoneNumber;
  String? role;

  AdminModel({
    this.profileImage,
     this.id,
     this.firstName,
     this.middleName,
     this.lastName,
     this.phoneNumber,
     this.email,
     this.role,

  });

  factory AdminModel.fromJson(Map<String, dynamic> json) => AdminModel(
        profileImage: json['profileImage'] ?? '',
        id: json['id'] ?? '',
        firstName: json['firstName'] ?? '',
        middleName: json['middleName'] ?? '',
        lastName: json['lastName'] ?? '',
        email: json['email'] ?? '',
        phoneNumber: json['phoneNumber'] ?? '',
        role: json['role'] ?? '',
      );
  Map<String, dynamic> toJson() => {
        'profileImage': profileImage,
        'id': id,
        'firstName': firstName,
        'middleName': middleName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phoneNumber,
        'role': 'admin',
      };

  AdminModel copyWith({
    String? name,
    image,
  }) =>
      AdminModel(
        id: id,
        firstName: name ?? this.firstName,
        middleName: middleName ?? this.middleName,
        lastName: lastName ?? this.lastName,
        profileImage: image ?? this.profileImage,
        email: email,
        phoneNumber: phoneNumber,
        role: 'admin',
      );
}
