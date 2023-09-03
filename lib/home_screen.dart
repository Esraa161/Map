import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();
  LocationData? _currentLocation;  // Variable to store the current location

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Check if location services are enabled
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        // Location services are still not enabled, handle it accordingly
        return;
      }
    }

    // Check if the app has permission to access location
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        // Permission to access location is not granted, handle it accordingly
        return;
      }
    }

    // Get the current location
    _currentLocation = await location.getLocation();

    // Update the state with the new location
    setState(() {});

    // Move the camera to the current location
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!), 14));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        /*appBar: AppBar(
          title: Text("Map App",style:TextStyle(color: Colors.white),),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),*/
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height:double.infinity,
              child: _currentLocation != null
                  ? GoogleMap(
                myLocationEnabled: true,
                compassEnabled: true,
                fortyFiveDegreeImageryEnabled: true,
               // liteModeEnabled: true,
                buildingsEnabled: true,
                indoorViewEnabled: true,
                mapToolbarEnabled: true,
                myLocationButtonEnabled: true,
                rotateGesturesEnabled: true,
               // trafficEnabled: true,
                onTap: (LatLng latLng) {
                  _markers.add(Marker(markerId: MarkerId('mark'), position: latLng));
                  setState(() {
                    Marker(
                      markerId: MarkerId('mark'),
                      position: latLng
                    );
                  });
                } ,
                markers: _createMarker(),
                //markers: _createMarker(),
                mapType:MapType.normal,
                initialCameraPosition: CameraPosition(
                  tilt: 22,
                  target: LatLng(_currentLocation!.latitude!,
                      _currentLocation!.longitude!),
                  zoom: 14.0,
                ),

                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              )
                  : Center(
                child: CircularProgressIndicator(),
              ),
            ),

          ],
        )

      ),
    );
  }
  /// show some Markes in Map ///////////////////////////////
  Set<Marker> _createMarker() {
    return {
      Marker(
        //that location of the user
          markerId: MarkerId("marker_1"),
          position:  LatLng(_currentLocation!.latitude!,
    _currentLocation!.longitude!),
          infoWindow: InfoWindow(title: 'Marker 1'),
          rotation: 90),
      Marker(
        markerId: MarkerId("marker_2"),
        position: LatLng(18.997962200185533, 72.8379758747611),
      ),
    Marker(
      markerId:MarkerId("marker_3"),
      position:LatLng(18.9979622001855, 72.83797587476) ,

    ),
      Marker(
        markerId:MarkerId("marker_3"),
        position:LatLng(18.9979622001855, 72.83797587476) ,

      ),
      Marker(
        markerId:MarkerId("marker_3"),
        position:_center,

      ),


    };
  }
  ///Map Type //////////////////////////////

  static const LatLng _center = const LatLng(45.521563, -122.677433);

  MapType _currentMapType= MapType.normal;

  void _onMapTypeButtonPressed(){
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }
  /// to put Mark on Map ///////////////////////////////////
Set<Marker> _markers = Set();

}