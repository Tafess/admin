// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:admin/controllers/firebase_storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin/controllers/firebase_firestore_helper.dart';
import 'package:admin/models/employee_model.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';

class DeliveryMansView extends StatefulWidget {
  const DeliveryMansView({Key? key}) : super(key: key);

  @override
  State<DeliveryMansView> createState() => _DeliveryMansViewState();
}

class _DeliveryMansViewState extends State<DeliveryMansView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestoreHelper _firestoreHelper = FirebaseFirestoreHelper();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
              labelText: 'Search by name',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: DefaultTabController(
            length: 3,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                toolbarHeight: 0,
                backgroundColor: Colors.white,
                bottom: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(width: 10, color: Colors.blue)),
                  labelPadding: EdgeInsets.symmetric(horizontal: 100),
                  tabs: [
                    Tab(
                      child: Text('All Delivery Mans',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal)),
                    ),
                    Tab(
                      child: Text('Accepted',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal)),
                    ),
                    Tab(
                      child: Text('Not Accepted',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal)),
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                controller: _tabController,
                children: [
                  buildDeliveryDataTable(
                    _firestoreHelper.getEmployeesStream(role: 'delivery'),
                  ),
                  buildDeliveryDataTable(_firestoreHelper.getEmployeesStream(
                      approved: true, role: 'delivery')),
                  buildDeliveryDataTable(_firestoreHelper.getEmployeesStream(
                      approved: false, role: 'delivery')),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void showDeliveryDetailsDialog(EmployeeModel delivery) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delivery man Details'),
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
                  child: delivery.idCard == null
                      ? CircleAvatar(
                          radius: 50,
                          child: Icon(Icons.person_outline),
                        )
                      : CircleAvatar(
                          radius: 70,
                          child: ClipOval(
                            child: Image.network(delivery.idCard!),
                          ),
                        ),
                ),
                Container(
                  color: Colors.white,
                  height: 30,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Primary Information'),
                      Text('Address Information'),
                    ],
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
                          Text('First Name:   ${delivery.firstName ?? ''}'),
                          Text('Middle Name:  ${delivery.middleName ?? ''}'),
                          Text('Last Name:    ${delivery.lastName ?? ''}'),
                          Text('Phone Number: ${delivery.phoneNumber ?? ''}'),
                          Text('Email:   ${delivery.email ?? ''}'),
                        ],
                      ),
                    ),
                    SizedBox(width: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Country:     ${delivery.country ?? ''}'),
                          Text('Region:      ${delivery.region ?? ''}'),
                          Text('City:        ${delivery.city ?? ''}'),
                          Text('Zone:        ${delivery.zone ?? ''}'),
                          Text('Woreda:      ${delivery.woreda ?? ''}'),
                          Text('Kebele:      ${delivery.kebele ?? ''}'),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget buildDeliveryDataTable(Stream<List<EmployeeModel>> sellersStream) {
    return StreamBuilder<List<EmployeeModel>>(
        stream: sellersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Center(
                    child: const Text('No delivery man data available')));
          } else {
            List<EmployeeModel> filteredSellers = snapshot.data!
                .where((seller) =>
                    seller.firstName!
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase()) ||
                    seller.middleName!
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase()) ||
                    seller.lastName!
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase()))
                .toList();
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  TouchMouseScrollable(
                    child: SingleChildScrollView(
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
                        rows: filteredSellers.asMap().entries.map((entry) {
                          final int rowIndex = entry.key;
                          final EmployeeModel seller = entry.value;
                          return DataRow(
                            color: MaterialStateColor.resolveWith((states) =>
                                rowIndex % 2 == 0
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
                                          .updateEmployee(seller);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
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
                                seller.idCard == null
                                    ? CircleAvatar(
                                        radius: 20,
                                        child: Icon(Icons.person),
                                      )
                                    : CircleAvatar(
                                        radius: 20,
                                        child: ClipOval(
                                          child: Image.network(
                                            seller.idCard!,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                              ),
                              DataCell(
                                Container(
                                  child: Text(
                                    seller.idCard ?? '',
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
                              showDeliveryDetailsDialog(seller);
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }
}
