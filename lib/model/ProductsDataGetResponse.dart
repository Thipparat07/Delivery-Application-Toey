// To parse this JSON data, do
//
//     final productsDataGetResponse = productsDataGetResponseFromJson(jsonString);

import 'dart:convert';

List<ProductsDataGetResponse> productsDataGetResponseFromJson(String str) => List<ProductsDataGetResponse>.from(json.decode(str).map((x) => ProductsDataGetResponse.fromJson(x)));

String productsDataGetResponseToJson(List<ProductsDataGetResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductsDataGetResponse {
    int productsId;
    String imageUrl;
    String name;
    String description;

    ProductsDataGetResponse({
        required this.productsId,
        required this.imageUrl,
        required this.name,
        required this.description,
    });

    factory ProductsDataGetResponse.fromJson(Map<String, dynamic> json) => ProductsDataGetResponse(
        productsId: json["productsID"],
        imageUrl: json["image_url"],
        name: json["name"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "productsID": productsId,
        "image_url": imageUrl,
        "name": name,
        "description": description,
    };
}
