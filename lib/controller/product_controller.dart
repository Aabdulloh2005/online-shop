import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_shop_animation/models/product_model.dart';
import 'package:online_shop_animation/services/product_firestore_service.dart';

class ProductController extends ChangeNotifier {
  final _firestoreProductService = ProductFirestoreService();

  Stream<QuerySnapshot> get product async* {
    yield* _firestoreProductService.getProducts();
  }
}
