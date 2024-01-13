// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:admin/constants/custome_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomepageScreen extends StatefulWidget {
  @override
  _HomepageScreenState createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  late Completer<GoogleMapController> _controller;
  final Set<Marker> markers = {};
  final Set<Polyline> polylines = {};
  final List<LatLng> polygonPoints = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Location _location = Location();

  @override
  void initState() {
    super.initState();
    _controller = Completer<GoogleMapController>();
    _setInitialLocation();
  }

  Future<void> _setInitialLocation() async {
    try {
      var currentLocation = await _location.getLocation();
      _moveCameraToLocation(
          LatLng(currentLocation.latitude!, currentLocation.longitude!));
    } catch (e) {
      print("Error getting current location: $e");
    }
  }

  void _moveCameraToLocation(LatLng location) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLng(location));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: CustomButton(
              width: 120,
              color: Colors.red.shade300,
              onPressed: () {
                setState(() {
                  markers.clear();
                  polylines.clear();
                });
              },
              title: ('Clear all'),
            ),
          ),
          CustomButton(
            color: Colors.green.shade200,
            width: 130,
            onPressed: _saveDeliveryRange,
            title: ('Save Range'),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Container(
              height: 1000,
              width: 1000,
              child: GoogleMap(
                onMapCreated: (controller) {
                  _controller.complete(controller);
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(0.0, 0.0),
                  zoom: 14.0,
                ),
                markers: Set<Marker>.from(markers),
                polylines: polylines,
                onTap: _handleTap,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleTap(LatLng tapPosition) {
    setState(() {
      polygonPoints.add(tapPosition);
      markers.clear();
      markers.addAll(polygonPoints.map((point) {
        return Marker(
          markerId: MarkerId(point.toString()),
          position: point,
        );
      }));

      // Update polylines
      if (polygonPoints.length > 1) {
        polylines.clear();
        polylines.add(Polyline(
          polylineId: PolylineId('polyline'),
          points: polygonPoints,
          color: Colors.blue,
          width: 3,
        ));
      }
    });
  }

  void _saveDeliveryRange() async {
    List<Map<String, double>> points = polygonPoints
        .map<Map<String, double>>((LatLng point) => {
              'latitude': point.latitude,
              'longitude': point.longitude,
            })
        .toList();

    await _firestore.collection('delivery_ranges').add({'points': points});

    // setState(() {
    //   markers.clear();
    //   polygonPoints.clear();
    // });
  }
}
