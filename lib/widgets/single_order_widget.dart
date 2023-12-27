// // ignore_for_file: prefer_const_constructors

// import 'package:admin/constants/constants.dart';
// import 'package:admin/controllers/firebase_firestore_helper.dart';
// import 'package:admin/models/order_model.dart';
// import 'package:admin/provider/app_provider.dart';
// import 'package:flutter/cupertino.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:provider/provider.dart';

// class SingleOrderWidget extends StatefulWidget {
//   final OrderModel orderModel;
//   const SingleOrderWidget({super.key, required this.orderModel});

//   @override
//   State<SingleOrderWidget> createState() => _SingleOrderWidgetState();
// }

// class _SingleOrderWidgetState extends State<SingleOrderWidget> {
//   @override
//   Widget build(BuildContext context) {
//     AppProvider appProvider = Provider.of<AppProvider>(context);
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: ExpansionTile(
//         tilePadding: EdgeInsets.zero,
//         backgroundColor: Colors.white,
//         collapsedShape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//             side: BorderSide(
//               color: Colors.white,
//             )),
//         shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey)),
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Expanded(
//               child: Container(
//                 height: 150,
//                 width: 80,
//                 color: Colors.grey.shade400,
//                 child: Image.network(
//                   widget.orderModel.products[0].image,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             Expanded(
//               flex: 3,
//               child: Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         widget.orderModel.products[0].name,
//                         style:
//                             const TextStyle(fontSize: 16, color: Colors.black),
//                       ),
//                       if (widget.orderModel.products.length > 1) ...[
//                         SizedBox(height: 10),
//                         Text(
//                             'Quantity: ${widget.orderModel.products[0].quantity.toString()}'),
//                       ],
//                       SizedBox(height: 10),
//                       FittedBox(
//                         child: Text(
//                             'Total price: ETB ${widget.orderModel.totalprice.toString()}'),
//                       ),
//                       SizedBox(height: 10),
//                       FittedBox(
//                         child: Text(
//                           'Order Status: ${widget.orderModel.status}',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: widget.orderModel.status == 'pending'
//                                 ? Colors.yellow.shade900
//                                 : (widget.orderModel.status == 'canceled'
//                                     ? Colors.red
//                                     : (widget.orderModel.status ==
//                                                 'completed' ||
//                                             widget.orderModel.status ==
//                                                 'delivery'
//                                         ? Colors.green
//                                         : Colors.black)),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 12),
//                       if (widget.orderModel.status == 'pending')
//                         CupertinoButton(
//                           onPressed: () async {
//                             await FirebaseFirestoreHelper.instance
//                                 .updateOrder(widget.orderModel, 'delivery');
//                             widget.orderModel.status = 'delivery';
//                             appProvider.updatePendingOrder(widget.orderModel);
//                             showMessage('Order Sent to Delivery');
//                             setState(() {});
//                           },
//                           child: Container(
//                             height: 40,
//                             width: double.infinity,
//                             alignment: Alignment.center,
//                             decoration: BoxDecoration(
//                                 color: Colors.blue,
//                                 borderRadius: BorderRadius.circular(8)),
//                             child: Text(
//                               'Send to Delivery',
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                         ),
//                       if (widget.orderModel.status == 'pending' ||
//                           widget.orderModel.status == 'delivery')
//                         CupertinoButton(
//                           onPressed: () async {
//                             if (widget.orderModel.status == 'pending') {
//                               widget.orderModel.status = 'canceled';
//                               await FirebaseFirestoreHelper.instance
//                                   .updateOrder(widget.orderModel, 'canceled');

//                               appProvider
//                                   .updateCancelPendingOrder(widget.orderModel);
//                             } else {
//                               widget.orderModel.status = 'canceled';
//                               await FirebaseFirestoreHelper.instance
//                                   .updateOrder(widget.orderModel, 'canceled');

//                               appProvider.updateCanceleDeliveryOrder(
//                                   widget.orderModel);
//                             }
//                           },
//                           child: Container(
//                             height: 40,
//                             width: double.infinity,
//                             alignment: Alignment.center,
//                             decoration: BoxDecoration(
//                                 color: Colors.red,
//                                 borderRadius: BorderRadius.circular(8)),
//                             child: Text(
//                               'Cancel order',
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                         ),
//                       SizedBox(height: 12),
//                     ],
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//         children: widget.orderModel.products.length > 1
//             ? [
//                 Text('Details'),
//                 Divider(color: Colors.grey),
//                 ...widget.orderModel.products.map((singleProduct) {
//                   return Row(
//                     children: [
//                       Expanded(
//                         child: Container(
//                           height: 80,
//                           width: 80,
//                           color: Colors.grey.shade400,
//                           child: Image.network(
//                             singleProduct.image,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         flex: 1,
//                         child: SizedBox(
//                           height: 140,
//                           child: Padding(
//                             padding: const EdgeInsets.all(12.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   singleProduct.name,
//                                   style: const TextStyle(
//                                       fontSize: 16, color: Colors.black),
//                                 ),
//                                 Text(
//                                     'Quantity:${singleProduct.quantity.toString()}'),
//                                 SizedBox(height: 10),
//                                 FittedBox(
//                                   child: Text(
//                                       'Price: ETB ${singleProduct.price.toString()}'),
//                                 ),
//                                 SizedBox(height: 10),
//                                 Text(
//                                   widget.orderModel.products[0].status,
//                                   style: const TextStyle(
//                                       fontSize: 16, color: Colors.black),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       )
//                     ],
//                   );
//                 }).toList()
//               ]
//             : [],
//       ),
//     );
//   }
// }
