// To parse this JSON data, do
//
//     final uesrsDataGetResponse = uesrsDataGetResponseFromJson(jsonString);

import 'dart:convert';

UesrsDataGetResponse uesrsDataGetResponseFromJson(String str) => UesrsDataGetResponse.fromJson(json.decode(str));

String uesrsDataGetResponseToJson(UesrsDataGetResponse data) => json.encode(data.toJson());

class UesrsDataGetResponse {
    User user;

    UesrsDataGetResponse({
        required this.user,
    });

    factory UesrsDataGetResponse.fromJson(Map<String, dynamic> json) => UesrsDataGetResponse(
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "user": user.toJson(),
    };
}

class User {
    int userId;
    String phoneNumber;
    String email;
    String password;
    String name;
    dynamic profilePicture;
    String address;
    dynamic gpsLocation;
    dynamic vehicleRegistration;
    String userType;
    String createdAt;

    User({
        required this.userId,
        required this.phoneNumber,
        required this.email,
        required this.password,
        required this.name,
        required this.profilePicture,
        required this.address,
        required this.gpsLocation,
        required this.vehicleRegistration,
        required this.userType,
        required this.createdAt,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["UserID"],
        phoneNumber: json["PhoneNumber"],
        email: json["Email"],
        password: json["Password"],
        name: json["Name"],
        profilePicture: json["ProfilePicture"],
        address: json["Address"],
        gpsLocation: json["GPSLocation"],
        vehicleRegistration: json["VehicleRegistration"],
        userType: json["UserType"],
        createdAt: json["CreatedAt"],
    );

    Map<String, dynamic> toJson() => {
        "UserID": userId,
        "PhoneNumber": phoneNumber,
        "Email": email,
        "Password": password,
        "Name": name,
        "ProfilePicture": profilePicture,
        "Address": address,
        "GPSLocation": gpsLocation,
        "VehicleRegistration": vehicleRegistration,
        "UserType": userType,
        "CreatedAt": createdAt,
    };
}
