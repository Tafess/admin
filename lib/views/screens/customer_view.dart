// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:admin/models/customer_model.dart';
import 'package:flutter/material.dart';
import 'package:admin/controllers/firebase_firestore_helper.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';

class CustomerViewScreen extends StatefulWidget {
  const CustomerViewScreen({Key? key}) : super(key: key);

  @override
  State<CustomerViewScreen> createState() => _CustomerViewScreenState();
}

class _CustomerViewScreenState extends State<CustomerViewScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestoreHelper _firestoreHelper = FirebaseFirestoreHelper();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
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
            length: 1,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                toolbarHeight: 0,
                backgroundColor: Colors.white,
                // bottom: TabBar(
                //   controller: _tabController,
                //   isScrollable: true,
                //   indicator: UnderlineTabIndicator(
                //       borderSide: BorderSide(width: 10, color: Colors.blue)),
                //   labelPadding: EdgeInsets.symmetric(horizontal: 100),
                //   tabs: [
                //     Tab(
                //       child: Text('All sellers',
                //           style: TextStyle(
                //               color: Colors.black,
                //               fontWeight: FontWeight.normal)),
                //     ),
                //     Tab(
                //       child: Text('Accepted',
                //           style: TextStyle(
                //               color: Colors.black,
                //               fontWeight: FontWeight.normal)),
                //     ),
                //     Tab(
                //       child: Text('Not Accepted',
                //           style: TextStyle(
                //               color: Colors.black,
                //               fontWeight: FontWeight.normal)),
                //     ),
                //   ],
                // ),
              ),
              body: TabBarView(
                controller: _tabController,
                children: [
                  buildCustomerDataTable(),
                  // buildSellerDataTable(_firestoreHelper.getCustomers()),
                  // buildSellerDataTable(_firestoreHelper.getCustomers()),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void showCustomerDetailsDialog(CustomerModel customer) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Customer Details'),
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
                  child: customer.image == null
                      ? CircleAvatar(
                          radius: 50,
                          child: Icon(Icons.person_outline),
                        )
                      : Container(
                          width: 400,
                          height: 300,
                          child: Image.network(customer.image!),
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
                          Text('First Name:   ${customer.name ?? ''}'),
                          Text('Emaile:  ${customer.email ?? ''}'),
                          Text('Id:    ${customer.id ?? ''}'),
                        ],
                      ),
                    ),
                    SizedBox(width: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [],
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

  Widget buildCustomerDataTable() {
    return StreamBuilder<List<CustomerModel>>(
        stream: _firestoreHelper.getCustomers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Center(child: const Text('No registered seller')));
          } else {
            List<CustomerModel> filteredCustomer = snapshot.data!
                .where((customer) =>
                    customer.name!
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase()) ||
                    customer.email!
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase()) ||
                    customer.id!
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
                            'Image',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                          DataColumn(
                              label: Text(
                            'Name',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                          DataColumn(
                              label: Text('Email',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('ID',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))),
                        ],
                        rows: filteredCustomer.asMap().entries.map((entry) {
                          final int rowIndex = entry.key;
                          final CustomerModel customer = entry.value;
                          return DataRow(
                            color: MaterialStateColor.resolveWith((states) =>
                                rowIndex % 2 == 0
                                    ? Colors.grey.shade300
                                    : Colors.white),
                            cells: [
                              DataCell(
                                customer.image == null
                                    ? CircleAvatar(
                                        radius: 20,
                                        child: Icon(Icons.person),
                                      )
                                    : CircleAvatar(
                                        radius: 20,
                                        child: ClipOval(
                                          child: Image.network(
                                            customer.image!,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                              ),
                              DataCell(
                                Container(
                                  child: Text(
                                    customer.name ?? '',
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                ),
                              ),
                              DataCell(
                                Container(
                                  child: Text(
                                    customer.email ?? '',
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                ),
                              ),
                              DataCell(
                                Container(
                                  child: Text(
                                    customer.id ?? '',
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                            onSelectChanged: (selected) {
                              showCustomerDetailsDialog(customer);
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
