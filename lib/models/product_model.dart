import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductModel extends ChangeNotifier {
  String id;
  String title;
  String description;
  double rating;
  double price;
  String firstColorImage;
  String productInfo;
  bool isLiked;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.productInfo,
    required this.rating,
    required this.price,
    required this.firstColorImage,
    required this.isLiked,
  });

  factory ProductModel.fromJson(QueryDocumentSnapshot snap) {
    return ProductModel(
      id: snap.id,
      title: snap["title"],
      description: snap["description"],
      productInfo: snap["productInfo"],
      rating: snap["rating"],
      price: snap['price'],
      firstColorImage: snap['firstColorImage'],
      isLiked: snap['isLiked'],
    );
  }
}
