import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyMap extends StatefulWidget {
  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  var myMarkers = HashSet<Marker>();
  final PageController _pageController = PageController();
  GoogleMapController? _mapController;

  // Generate a random LatLng within Cairo
  LatLng generateRandomLocation() {
    final random = Random();
    final lat =
        30.0444 + random.nextDouble() * 0.2; // Adjust the range as needed
    final lng =
        31.2357 + random.nextDouble() * 0.2; // Adjust the range as needed
    return LatLng(lat, lng);
  }
  void animateToMarker(int index) async {
    final markerId = MarkerId(index.toString());
    final marker = myMarkers.firstWhere(
          (marker) => marker.markerId == markerId,
    );
    if (marker != null && _mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLng(marker.position),
      );
    }
  }

  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 1),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Completer<GoogleMapController> _controller =
        Completer<GoogleMapController>();
    const CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(30.0444, 31.2357),
      zoom: 10,
    );
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Container(
            width: double.infinity,
            height: 869,
            child: GoogleMap(
              markers: myMarkers,
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                _mapController = controller;
                setState(() {
                  for (int i = 0; i < 10; i++) {
                    final randomLocation = generateRandomLocation();
                    myMarkers.add(
                      Marker(
                        onTap: (){
                          print(r"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");

                          print(i);
                          _goToPage(i);
                        },
                        icon: BitmapDescriptor.defaultMarker,
                        markerId: MarkerId(i.toString()),
                        position: randomLocation,
                        infoWindow: InfoWindow(
                          title: 'Gym Name ${i + 1}',
                          snippet: 'Gym Address ${i + 1}',
                          onTap: () {
                            print(r"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");

                            print(i);
                            _goToPage(i);

                          },
                        ),
                      ),
                    );
                  }
                });
              },
            ),
          ),
          Positioned(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 700,
                bottom: 10,
                left: 15,
                right: 15,
              ),
              child: PageView.builder(
                controller: _pageController,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       /* const Image(
                          image: AssetImage(
                            "assets/images/treadmill-machine.png",
                          ),
                        ),*/
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 15),
                              child: Text(
                                'Gym Name ${index + 1}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Text(
                              'Gym Address ${index + 1}',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                onPageChanged: (int index) {
                  animateToMarker(index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }


}
