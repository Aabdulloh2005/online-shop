import 'package:flutter/material.dart';
import 'package:online_shop_animation/controller/product_controller.dart';
import 'package:online_shop_animation/models/product_model.dart';
import 'package:online_shop_animation/services/product_firestore_service.dart';
import 'package:online_shop_animation/views/widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: ProductFirestoreService().getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: Text("Apida malumot yoq"),
            );
          }
          final data = snapshot.data!.docs;
          return GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              childAspectRatio: 0.65,
            ),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final product = ProductModel.fromJson(data[index]);
              // print(product.title);
              return ChangeNotifierProvider<ProductModel>.value(
                value: product,
                child: ProductItem(
                  index: index,
                ),
              );
            },
          );
        });
  }
}

















// import 'package:flutter/material.dart';
// import 'package:online_shop_animation/controller/product_controller.dart';
// import 'package:online_shop_animation/models/product_model.dart';
// import 'package:online_shop_animation/views/widgets/product_item.dart';
// import 'package:provider/provider.dart';

// class ProductGrid extends StatelessWidget {
//   const ProductGrid({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ProductController>(
//       builder: (context, productController, child) {
//         return GridView.builder(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             crossAxisSpacing: 10.0,
//             childAspectRatio: 0.65,
//           ),
//           itemCount: productController.product.length,
//           itemBuilder: (context, index) {
//             final product = productController.product[index];
//             return ChangeNotifierProvider<ProductModel>.value(
//               value: product,
//               child:  ProductItem(index: index,),
//             );
//           },
//         );
//       },
//     );
//   }
// }