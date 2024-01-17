// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, unnecessary_null_comparison

import 'dart:math';

import 'package:admin/constants/routes.dart';
import 'package:admin/controllers/firebase_firestore_helper.dart';
import 'package:admin/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductView extends StatefulWidget {
  static const String id = 'product-view';
  const ProductView({Key? key}) : super(key: key);

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final int index = 0;
  final TextEditingController _searchController = TextEditingController();

  final FirebaseFirestoreHelper _firestoreHelper = FirebaseFirestoreHelper();

  /////////////////////////
  ///
  void showProductDetailsDialog(ProductModel product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Product Details'),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: EdgeInsets.zero,
                      child: Container(
                        width: 40,
                        alignment: Alignment.center,
                        color: Colors.red,
                        child: Text(
                          'X',
                          style: TextStyle(color: Colors.white, fontSize: 40),
                        ),
                      ),
                    ))
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(),
          ),
          contentPadding: EdgeInsets.fromLTRB(30, 0, 0, 20),
          titlePadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
          content: Container(
            color: Colors.white,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 100,
                  width: double.infinity,
                  child: product.image == null
                      ? CircleAvatar(
                          radius: 50,
                          child: Icon(Icons.person_outline),
                        )
                      : CircleAvatar(
                          radius: 70,
                          child: ClipOval(
                            child: Image.network(product.image),
                          ),
                        ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Product name:   ${product.name ?? ''}'),
                          Text('Price:  ${product.price ?? ''}'),
                          Text('Discount:    ${product.discount ?? ''}'),
                          Text('Description: ${product.description ?? ''}'),
                          Text('No of Items:   ${product.quantity ?? ''}'),
                        ],
                      ),
                    ),
                    SizedBox(width: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          // Text('Country:     ${product.country ?? ''}'),
                          // Text('Region:      ${product.region ?? ''}'),
                          // Text('City:        ${product.city ?? ''}'),
                          // Text('Zone:        ${product.zone ?? ''}'),
                          // Text('Woreda:      ${product.woreda ?? ''}'),
                          // Text('Kebele:      ${product.kebele ?? ''}'),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // AppProvider appProvider = Provider.of<AppProvider>(context);
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: 'Search product by name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: Scaffold(
              backgroundColor: Colors.white,
              // appBar: AppBar(
              //   title: const Text(('Products')),
              //   actions: [
              //     Padding(
              //       padding: const EdgeInsets.all(10.0),
              //       child: StreamBuilder<List<ProductModel>>(
              //         stream: getProducts(),
              //         builder: (context, snapshot) {
              //           int itemCount =
              //               snapshot.hasData ? snapshot.data!.length : 0;
              //           return Container(
              //             alignment: Alignment.center,
              //             width: 80,
              //             height: 40,
              //             color: Colors.green,
              //             child: Text(
              //               itemCount.toString(),
              //               style: const TextStyle(color: Colors.white),
              //             ),
              //           );
              //         },
              //       ),
              //     ),
              //   ],
              // ),

              body: StreamBuilder<List<ProductModel>>(
                stream: _firestoreHelper.getProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: const Text('No data available'));
                  } else {
                    List<ProductModel> filteredProducts = snapshot.data!
                        .where((product) => product.name
                            .toLowerCase()
                            .contains(_searchController.text.toLowerCase()))
                        .toList();

                    return Expanded(
                      child: Center(
                        child: Stack(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                children: [
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      headingRowColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => Colors.grey.shade700),
                                      showCheckboxColumn: false,
                                      columnSpacing: 100,
                                      dataTextStyle:
                                          TextStyle(fontFamily: 'Normal'),
                                      columns: const [
                                        DataColumn(
                                            label: Text(
                                          'Image',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )),
                                        DataColumn(
                                            label: Text(
                                          'Id',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )),
                                        DataColumn(
                                            label: Text('Name',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        DataColumn(
                                            label: Text('Quantity',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        DataColumn(
                                            label: Text('Price',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        DataColumn(
                                            label: Text('Discount',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold))),
                                      ],
                                      rows: filteredProducts
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                        final int rowIndex = entry.key;
                                        final ProductModel product =
                                            entry.value;
                                        return DataRow(
                                          color: MaterialStateColor.resolveWith(
                                              (states) => rowIndex % 2 == 0
                                                  ? Colors.grey.shade300
                                                  : Colors.white),
                                          cells: [
                                            DataCell(
                                              SizedBox(
                                                height: 30,
                                                width: 30,
                                                child: Image.network(
                                                  product.image,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Container(
                                                //  width: 60,
                                                child: Text(
                                                  product.id,
                                                  style: const TextStyle(
                                                      //    overflow: TextOverflow.ellipsis,
                                                      fontSize: 14,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Container(
                                                //  width: 60,
                                                child: Text(
                                                  product.name,
                                                  style: const TextStyle(
                                                      //  overflow: TextOverflow.ellipsis,
                                                      fontSize: 14,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Container(
                                                //  width: 30,
                                                child: Text(
                                                  product.quantity.toString(),
                                                  //  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                product.price
                                                    .toStringAsFixed(2),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  decoration:
                                                      product.discount != 0.0
                                                          ? TextDecoration
                                                              .lineThrough
                                                          : null,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                product.discount == 0.0
                                                    ? ''
                                                    : product.discount
                                                        .toStringAsFixed(2),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                          onSelectChanged: (selected) {
                                            showProductDetailsDialog(product);
                                            // Routes.instance.push(
                                            //   widget: ProductDetails(
                                            //     productModel: product,
                                            //     index: index,
                                            //   ),
                                            //   context: context,
                                            // );
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 100,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}





