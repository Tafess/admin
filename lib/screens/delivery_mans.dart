// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:admin/constants/primary_button.dart';
import 'package:admin/constants/routes.dart';
import 'package:admin/controllers/firebase_firestore_helper.dart';
import 'package:admin/models/seller_model.dart';
import 'package:admin/widgets/add_product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DeliveryMansView extends StatefulWidget {
  static const String id = 'product-view';

  const DeliveryMansView({Key? key}) : super(key: key);

  @override
  State<DeliveryMansView> createState() => _DeliveryMansViewState();
}

class _DeliveryMansViewState extends State<DeliveryMansView> {
  final int index = 0;

  @override
  Widget build(BuildContext context) {
    // AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(('Sellers')),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: StreamBuilder<List<SellerModel>>(
              stream: getSellers(),
              builder: (context, snapshot) {
                int itemCount = snapshot.hasData ? snapshot.data!.length : 0;
                return Container(
                  alignment: Alignment.center,
                  width: 80,
                  height: 40,
                  color: Colors.green,
                  child: Text(
                    itemCount.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<SellerModel>>(
        stream: getSellers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No registered seller');
          } else {
            return Center(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: MaterialStateColor.resolveWith(
                                (states) => Colors.grey.shade700),
                            showCheckboxColumn: false,
                            columnSpacing: 100,
                            dataTextStyle: TextStyle(fontFamily: 'Normal'),
                            columns: const [
                              DataColumn(
                                  label: Text(
                                'Permission',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
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
                                  label: Text('First Name',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('Middle Name',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('Last Name',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('Phone Number',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('Email',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('Country',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('Region',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('City',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('Zone',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('Woreda',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('Kebele',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold))),
                            ],
                            rows: snapshot.data!.asMap().entries.map((entry) {
                              final int rowIndex = entry.key;
                              final SellerModel seller = entry.value;
                              return DataRow(
                                color: MaterialStateColor.resolveWith(
                                    (states) => rowIndex % 2 == 0
                                        ? Colors.grey.shade300
                                        : Colors.white),
                                cells: [
                                  DataCell(
                                    Container(
                                      width: 100,
                                      alignment: Alignment.center,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          if (seller.approved == false) {
                                            setState(() {
                                              seller.approved = true;
                                            });
                                          } else {
                                            setState(() {
                                              seller.approved = false;
                                            });
                                          }

                                          await FirebaseFirestoreHelper.instance
                                              .updateSeller(seller);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ),
                                        child: Text(
                                          seller.approved == false
                                              ? 'Accept'
                                              : 'Reject',
                                          style: TextStyle(
                                            color: seller.approved == false
                                                ? Colors.green
                                                : Colors.red,
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: Image.network(
                                        seller.image ?? '',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      child: Text(
                                        seller.id ?? '',
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      child: Text(
                                        seller.firstName ?? '',
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      child: Text(
                                        seller.middleName ?? '',
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      child: Text(
                                        seller.lastName ?? '',
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      child: Text(
                                        seller.phoneNumber ?? '',
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      child: Text(
                                        seller.email ?? '',
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      child: Text(
                                        seller.country ?? '',
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      child: Text(
                                        seller.region ?? '',
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      child: Text(
                                        seller.city ?? '',
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      child: Text(
                                        seller.zone ?? '',
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      child: Text(
                                        seller.woreda ?? '',
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      child: Text(
                                        seller.kebele ?? '',
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ],
                                onSelectChanged: (selected) {
                                  // Handle row selection
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
                  Positioned(
                    bottom: 30,
                    right: 2,
                    child: FloatingActionButton(
                      backgroundColor: Colors.green,
                      onPressed: () {
                        Routes.instance.push(
                          widget: const AddProduct(),
                          context: context,
                        );
                      },
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Stream<List<SellerModel>> getSellers() {
    return _firebaseFirestore
        .collection('sellers')
        .snapshots()
        .map((querySnapshot) {
      List<SellerModel> sellerModel = querySnapshot.docs
          .map((e) => SellerModel.fromJson(e.data()))
          .toList();
      return sellerModel;
    });
  }
}
