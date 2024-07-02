import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_shop_animation/models/product_model.dart';

class ProductFirestoreService {
  final _firestoreService = FirebaseFirestore.instance.collection('products');
  Stream<QuerySnapshot> getProducts() async* {
    yield* _firestoreService.snapshots();
  }

  void addProducts(ProductModel product) {
    _firestoreService.add(
      {
        "id": product.id,
        "title": product.title,
        "description": product.description,
        "productInfo": product.productInfo,
        "rating": product.rating,
        "price": product.price,
        "firstColorImage": product.firstColorImage,
        "isLiked": product.isLiked,
      },
    );
  }
}
