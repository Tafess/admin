import 'package:admin/constants/routes.dart';
import 'package:admin/constants/top_titles.dart';
import 'package:admin/models/product_model.dart';
import 'package:admin/provider/app_provider.dart';
import 'package:admin/widgets/add_product.dart';
import 'package:admin/widgets/single_product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductView extends StatefulWidget {
  static const String id = 'product-view';
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('products'),
      //   actions: [
      //     IconButton(
      //       onPressed: () {
      //         Routes.instance.push(widget: AddProduct(), context: context);
      //       },
      //       icon: Icon(Icons.add_circle),
      //     ),
      //   ],
      // ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TopTitles(
                title: 'Products',
                subtitle: appProvider.getProducts.length.toString()),
            GridView.builder(
                padding: const EdgeInsets.only(bottom: 20, top: 20),
                shrinkWrap: true,
                primary: false,
                itemCount: appProvider.getProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 0.8,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    crossAxisCount: 4),
                itemBuilder: (ctx, index) {
                  var singleProduct = appProvider.getProducts[index];
                  return SingleProductItem(
                      singleProduct: singleProduct, index: index);
                }),
          ],
        ),
      ),
    );
  }
}
