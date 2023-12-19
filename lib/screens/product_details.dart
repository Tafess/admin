import 'package:admin/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProductDetails extends StatelessWidget {
  static const String id = 'product-details';
  const ProductDetails({super.key, required ProductModel productModel, required int index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product details'), actions: []),
      
    );
  }
}
