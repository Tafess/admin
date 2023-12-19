// import 'package:admin/models/product_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_web_data_table/web_data_table.dart';

// class ProductDataTable extends StatefulWidget {
//   final List<ProductModel> productData;

//   const ProductDataTable({Key? key, required this.productData})
//       : super(key: key);

//   @override
//   State<ProductDataTable> createState() => _ProductDataTableState();
// }

// class _ProductDataTableState extends State<ProductDataTable> {
//   late String _sortColumnName;
//   late bool _sortAscending;
//   List<String>? _filterTexts;
//   bool _willSearch = true;
//   Timer? _timer;
//   int? _latestTick;
//   List<String> _selectedRowKeys = [];
//   int _rowsPerPage = 10;

//   @override
//   void initState() {
//     super.initState();
//     _sortColumnName =
//         'name'; // Change this to the desired default sorting column
//     _sortAscending = false;
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (!_willSearch) {
//         if (_latestTick != null && timer.tick > _latestTick!) {
//           _willSearch = true;
//         }
//       }
//       if (_willSearch) {
//         _willSearch = false;
//         _latestTick = null;
//         setState(() {
//           if (_filterTexts != null && _filterTexts!.isNotEmpty) {
//             _filterTexts = _filterTexts;
//             print('filterTexts = $_filterTexts');
//           }
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _timer?.cancel();
//     _timer = null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Product Data Table'),
//         ),
//         body: SingleChildScrollView(
//           child: Container(
//             padding: const EdgeInsets.all(8.0),
//             child: WebDataTable(
//               header: Text('Product Data'),
//               actions: [
//                 if (_selectedRowKeys.isNotEmpty)
//                   SizedBox(
//                     height: 50,
//                     width: 100,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         print('Delete!');
//                         setState(() {
//                           _selectedRowKeys.clear();
//                         });
//                       },
//                       child: Text('Delete'),
//                     ),
//                   ),
//                 Container(
//                   width: 300,
//                   child: TextField(
//                     decoration: InputDecoration(
//                       prefixIcon: Icon(Icons.search),
//                       hintText: 'Increment search...',
//                       focusedBorder: const OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Color(0xFFCCCCCC),
//                         ),
//                       ),
//                       border: const OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Color(0xFFCCCCCC),
//                         ),
//                       ),
//                     ),
//                     onChanged: (text) {
//                       _filterTexts = text.trim().split(' ');
//                       _willSearch = false;
//                       _latestTick = _timer?.tick;
//                     },
//                   ),
//                 ),
//               ],
//               source: WebDataTableSource(
//                 sortColumnName: _sortColumnName,
//                 sortAscending: _sortAscending,
//                 filterTexts: _filterTexts,
//                 columns: [
//                   WebDataColumn(
//                     name: 'id',
//                     label: const Text('ID'),
//                     dataCell: (value) => DataCell(Text('$value')),
//                   ),
//                   WebDataColumn(
//                     name: 'image',
//                     label: const Text('Image'),
//                     dataCell: (value) => DataCell(Image.network('$value')),
//                   ),
//                   WebDataColumn(
//                     name: 'name',
//                     label: const Text('Name'),
//                     dataCell: (value) => DataCell(Text('$value')),
//                   ),
//                   WebDataColumn(
//                     name: 'price',
//                     label: const Text('Price'),
//                     dataCell: (value) => DataCell(Text('$value')),
//                   ),
//                   WebDataColumn(
//                     name: 'quantity',
//                     label: const Text('Quantity'),
//                     dataCell: (value) => DataCell(Text('$value')),
//                     sortable: false,
//                   ),
//                 ],
//                 rows: widget.productData.map((product) {
//                   return WebDataRow(
//                     cells: [
//                       WebDataCell(Text('${product.id}')),
//                       WebDataCell(Image.network('${product.image}')),
//                       WebDataCell(Text('${product.name}')),
//                       WebDataCell(Text('${product.price}')),
//                       WebDataCell(Text('${product.quantity}')),
//                     ],
//                   );
//                 }).toList(),
//                 selectedRowKeys: _selectedRowKeys,
//                 onSelectRows: (keys) {
//                   print('onSelectRows(): count = ${keys.length} keys = $keys');
//                   setState(() {
//                     _selectedRowKeys = keys;
//                   });
//                 },
//                 primaryKeyName: 'id',
//               ),
//               horizontalMargin: 100,
//               onSort: (columnName, ascending) {
//                 print(
//                     'onSort(): columnName = $columnName, ascending = $ascending');
//                 setState(() {
//                   _sortColumnName = columnName;
//                   _sortAscending = ascending;
//                 });
//               },
//               onRowsPerPageChanged: (rowsPerPage) {
//                 print('onRowsPerPageChanged(): rowsPerPage = $rowsPerPage');
//                 setState(() {
//                   if (rowsPerPage != null) {
//                     _rowsPerPage = rowsPerPage;
//                   }
//                 });
//               },
//               rowsPerPage: _rowsPerPage,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
// Future<List<ProductModel>> getProducts() async {
//   QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firebaseFirestore
//       .collectionGroup('products')
//       // .where('sellerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
//       .get();

//   print('Number of Products: ${querySnapshot.size}');

//   List<ProductModel> productList =
//       querySnapshot.docs.map((e) => ProductModel.fromJson(e.data())).toList();

//   print('Product List: $productList');
//   return productList;
// }
