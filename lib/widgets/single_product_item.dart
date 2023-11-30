
import 'package:admin/constants/routes.dart';
import 'package:admin/models/product_model.dart';
import 'package:admin/provider/app_provider.dart';
import 'package:admin/screens/product_details.dart';
import 'package:admin/widgets/edit_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SingleProductItem extends StatefulWidget {
  final int index;
  final ProductModel singleProduct;
  const SingleProductItem({
    super.key,
    required this.singleProduct,
    required this.index,
  });

  @override
  State<SingleProductItem> createState() => _SingleProductItemState();
}

class _SingleProductItemState extends State<SingleProductItem> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          Routes.instance.push(widget: ProductDetails(), context: context);
        },
        child: Stack(
          //   alignment: Alignment.topRight,
          children: [
            Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 60,
                        width: double.infinity,
                        child: Image.network(
                          widget.singleProduct.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      widget.singleProduct.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'ETB ${widget.singleProduct.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 6.0,
                    ),
                  ]),
            ),
            Positioned(
              right: 0.2,
              child: Row(
                children: [
                  IgnorePointer(
                    ignoring: isLoading,
                    child: GestureDetector(
                      onTap: () async {
                        setState(() {
                          isLoading = true;
                        });
                        await appProvider
                            .deleteProductFromFirebase(widget.singleProduct);
                        setState(() {
                          isLoading = false;
                        });
                      },
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Routes.instance.push(
                          widget: EditProduct(
                              productModel: widget.singleProduct,
                              index: widget.index),
                          context: context);
                    },
                    child: const Icon(
                      Icons.edit,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
