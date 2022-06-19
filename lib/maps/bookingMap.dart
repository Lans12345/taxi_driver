import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive/google_map_api.dart';
import 'package:drive/provider/userCredentialsProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../home/HomePage.dart';

class BookingMap extends StatefulWidget {
  const BookingMap({Key? key}) : super(key: key);

  @override
  _BookingMapState createState() => _BookingMapState();
}

class _BookingMapState extends State<BookingMap> {
  LatLng sourceLocation = const LatLng(28.432864, 77.002563);
  LatLng destinationLatlng = const LatLng(28.431626, 77.002475);

  final Completer<GoogleMapController> _controller = Completer();

  final Set<Marker> _marker = <Marker>{};

  final Set<Polyline> _polylines = <Polyline>{};
  List<LatLng> polylineCoordinates = [];
  List<LatLng> polylineCoordinates1 = [];
  late PolylinePoints polylinePoints;
  late PolylinePoints polylinePoints1;

  late StreamSubscription<LocationData> subscription;

  LocationData? currentLocation;
  late LocationData destinationLocation;
  late Location location;

  final geo = GeoFlutterFire();

  @override
  void initState() {
    super.initState();
    getData();
    getData1();
    getData2();
    getData3();

    location = Location();
    polylinePoints = PolylinePoints();
    polylinePoints1 = PolylinePoints();

    subscription = location.onLocationChanged.listen((clocation) {
      currentLocation = clocation;

      updatePinsOnMap();
    });

    setInitialLocation();
  }

  DateTime datetime1 = DateTime.now();

  late double myMonth = 0;
  late double myWeek = 0;
  late double myYear = 0;

  getData1() async {
    String month = DateFormat.MMMM().format(datetime1);

    // Use provider
    var collection = FirebaseFirestore.instance
        .collection('sales')
        .where('type', isEqualTo: 'month');

    var querySnapshot = await collection.get();
    setState(() {
      for (var queryDocumentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = queryDocumentSnapshot.data();
        myMonth = data[month];
      }
    });
  }

  getData2() async {
    String week = DateFormat.EEEE().format(datetime1);

    // Use provider
    var collection = FirebaseFirestore.instance
        .collection('sales')
        .where('type', isEqualTo: 'week');

    var querySnapshot = await collection.get();
    setState(() {
      for (var queryDocumentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = queryDocumentSnapshot.data();

        myWeek = data[week];
      }
    });
  }

  getData3() async {
    String year = DateFormat.y().format(datetime1);
    // Use provider
    var collection = FirebaseFirestore.instance
        .collection('sales')
        .where('type', isEqualTo: 'year');

    var querySnapshot = await collection.get();
    setState(() {
      for (var queryDocumentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = queryDocumentSnapshot.data();

        myYear = data[year];
      }
    });
  }

  void setInitialLocation() async {
    await location.getLocation().then((value) {
      currentLocation = value;
      setState(() {});
    });

    destinationLocation = LocationData.fromMap({
      "latitude": destinationLatlng.latitude,
      "longitude": destinationLatlng.longitude,
    });
  }

  void showLocationPins() {
    // Driver Current Location
    var sourceposition = LatLng(
        currentLocation!.latitude ?? 0.0, currentLocation!.longitude ?? 0.0);
    _marker.add(Marker(
      markerId: const MarkerId('sourcePosition'),
      position: sourceposition,
    ));

    // Pick Up Location Marker
    var pickUpPosition = LatLng(
        context.read<UserProvider>().getPickUpLocationLatitude,
        context.read<UserProvider>().getPickUpLocationLongitude);
    _marker.add(
      Marker(
        infoWindow: const InfoWindow(title: 'Pick Up Location of Passenger'),
        markerId: const MarkerId('pickUpLocationOfPassenger'),
        position: pickUpPosition,
      ),
    );

    // Destination Marker
    var destinationPosition = LatLng(
        context.read<UserProvider>().getDestinationLocationLatitude,
        context.read<UserProvider>().getDestinationLocationLongitude);
    _marker.add(
      Marker(
        infoWindow:
            const InfoWindow(title: 'Destination Location of Passenger'),
        markerId: const MarkerId('destinationLocationOfPassenger'),
        position: destinationPosition,
      ),
    );

    setPolylinesInMap();
  }

  changePolyline() async {
    var result = await polylinePoints1.getRouteBetweenCoordinates(
      GoogleMapApi().url,
      // Pick Up Location of Passenger
      PointLatLng(context.read<UserProvider>().getPickUpLocationLatitude,
          context.read<UserProvider>().getPickUpLocationLongitude),
      // Destination Location of Passenger
      PointLatLng(context.read<UserProvider>().getDestinationLocationLatitude,
          context.read<UserProvider>().getDestinationLocationLongitude),
    );

    if (result.points.isNotEmpty) {
      for (var pointLatLng in result.points) {
        polylineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      }
    }

    setState(() {
      polylineCoordinates.clear();
      _polylines.clear();
      if (result.points.isNotEmpty) {
        for (var pointLatLng in result.points) {
          polylineCoordinates
              .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
        }
      }
      _polylines.add(Polyline(
        width: 5,
        polylineId: const PolylineId('polyline1'),
        color: Colors.red,
        points: polylineCoordinates,
      ));
    });
  }

  void update() {
    FirebaseFirestore.instance
        .collection('driver')
        .doc(
            '${context.read<UserProvider>().getUsername}-${context.read<UserProvider>().getPassword}')
        .update({
      'latitude': currentLocation!.latitude,
      'longitude': currentLocation!.longitude,
    });
  }

  void setPolylinesInMap() async {
    // Pick Up Location Polyline
    var result = await polylinePoints.getRouteBetweenCoordinates(
      GoogleMapApi().url,
      // Current Location of Driver
      PointLatLng(
          currentLocation!.latitude ?? 0.0, currentLocation!.longitude ?? 0.0),
      // Pick Up Location of Passenger
      PointLatLng(context.read<UserProvider>().getPickUpLocationLatitude,
          context.read<UserProvider>().getPickUpLocationLongitude),
    );

    // Destination Location Polyline
    var result1 = await polylinePoints1.getRouteBetweenCoordinates(
      GoogleMapApi().url,
      // Pick Up Location of Passenger
      PointLatLng(context.read<UserProvider>().getPickUpLocationLatitude,
          context.read<UserProvider>().getPickUpLocationLongitude),
      // Destination Location of Passenger
      PointLatLng(context.read<UserProvider>().getDestinationLocationLatitude,
          context.read<UserProvider>().getDestinationLocationLongitude),
    );

    if (result.points.isNotEmpty) {
      for (var pointLatLng in result.points) {
        polylineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      }
    }

    if (result1.points.isNotEmpty) {
      for (var pointLatLng1 in result.points) {
        polylineCoordinates1.add(
          LatLng(pointLatLng1.latitude, pointLatLng1.longitude),
        );
      }
    }

    setState(() {
      _polylines.add(Polyline(
        width: 5,
        polylineId: const PolylineId('polyline1'),
        color: Colors.blue,
        points: polylineCoordinates,
      ));
    });
  }

  addMarker() async {
    var sourcePosition = LatLng(
        currentLocation!.latitude ?? 0.0, currentLocation!.longitude ?? 0.0);
    _marker.add(Marker(
      markerId: const MarkerId('sourcePosition'),
      icon: await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(
          size: Size(24, 24),
        ),
        'lib/images/driver.png',
      ),
      position: sourcePosition,
    ));
  }

  void updatePinsOnMap() async {
    CameraPosition cameraPosition = CameraPosition(
      zoom: 16,
      target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
    );

    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    setState(() {
      _marker.removeWhere((marker) => marker.mapsId.value == 'sourcePosition');
      addMarker();
    });
  }

  late String driverName = '';
  late String driverContactNumber = '';
  late String profilePicture = '';
  late String carPicture = '';
  late String carModel = '';
  late String carPlateNumber = '';
  late String date = '';
  late String time = '';
  late String destination = '';

  late String instruction = 'Follow the Blue Route';
  late Color col = Colors.blue;
  late String firstName = '';
  late String lastName = '';

  getData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      driverName = prefs.getString('driverName')!;
      driverContactNumber = prefs.getString('driverContactNumber')!;
      profilePicture = prefs.getString('profilePicture')!;
      carPicture = prefs.getString('carPicture')!;
      carModel = prefs.getString('carModel')!;
      carPlateNumber = prefs.getString('carPlateNumber')!;
      firstName = prefs.getString('firstName')!;
      lastName = prefs.getString('lastName')!;
    });
  }

  var dt = DateTime.now();

  Future book() async {
    final docUser = FirebaseFirestore.instance.collection('driver').doc();

    final json = {
      'driverName': driverName,
      'driverContactNumber': driverContactNumber,
      'driverProfilePicture': profilePicture,
      'carPicture': carPicture,
      'carModel': carModel,
      'carPlateNumber': carPlateNumber,
      'destination': context.read<UserProvider>().getDestination,
      'date': dt.month.toString() +
          '/' +
          dt.day.toString() +
          '/' +
          dt.year.toString(),
      'time': dt.hour.toString() +
          '/' +
          dt.minute.toString() +
          '/' +
          dt.second.toString(),
      'passengerName': context.read<UserProvider>().getPassengerFirstName +
          ' ' +
          context.read<UserProvider>().getPassengerLastName,
      'type': 'history',
      'username': context.read<UserProvider>().getUsername,
      'password': context.read<UserProvider>().getPassword,
      'amountPaid': context.read<UserProvider>().amountToPay,
    };

    await docUser.set(json);

    /*
    FirebaseFirestore.instance
        .collection('driver')
        .doc(context.read<UserProvider>().getDate +
            '-' +
            context.read<UserProvider>().getTime +
            '-' +
            context.read<UserProvider>().getPassengerFirstName +
            '' +
            context.read<UserProvider>().getPassengerLastName)
        .delete();
        */
    print(context.read<UserProvider>().getDate +
        '-' +
        context.read<UserProvider>().getTime +
        '-' +
        context.read<UserProvider>().getPassengerFirstName +
        ' ' +
        context.read<UserProvider>().getPassengerLastName);
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
      zoom: 20,
      target: currentLocation != null
          ? LatLng(currentLocation!.latitude ?? 0.0,
              currentLocation!.longitude ?? 0.0)
          : const LatLng(0.0, 0.0),
    );

    return currentLocation == null
        ? Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          )
        : SafeArea(
            child: Scaffold(
            body: Stack(children: [
              GoogleMap(
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
                compassEnabled: false,
                markers: _marker,
                polylines: _polylines,
                mapType: MapType.normal,
                initialCameraPosition: initialCameraPosition,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);

                  showLocationPins();
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 250, left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Image(
                      width: 35,
                      color: Colors.blue,
                      image: AssetImage('lib/images/minus.png'),
                    ),
                    Text('Blue Line:\nyour route',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 10,
                          color: Colors.blue,
                        )),
                    Image(
                      width: 35,
                      color: Colors.red,
                      image: AssetImage('lib/images/minus.png'),
                    ),
                    Text("Red Line:\npassenger's route",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 10,
                          color: Colors.red,
                        )),
                  ],
                ),
              ),
              SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(1000),
                        ),
                        child: ExpansionTile(
                          collapsedIconColor: Colors.red,
                          backgroundColor: Colors.white,
                          leading: const Icon(
                            Icons.person,
                            color: Colors.red,
                          ),
                          title: const Text(
                            'Passenger',
                            style: TextStyle(
                                fontWeight: FontWeight.w300, color: Colors.red),
                          ),
                          children: [
                            CircleAvatar(
                              minRadius: 40,
                              maxRadius: 40,
                              backgroundImage: NetworkImage(context
                                  .read<UserProvider>()
                                  .getPassengerProfilePicture),
                            ),
                            ListTile(
                              tileColor: Colors.white,
                              title: Text(context
                                      .read<UserProvider>()
                                      .getPassengerFirstName +
                                  ' ' +
                                  context
                                      .read<UserProvider>()
                                      .getPassengerLastName),
                              subtitle: const Text(
                                'Full Name',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 10),
                              ),
                            ),
                            ListTile(
                              tileColor: Colors.white,
                              title: Text(context
                                  .read<UserProvider>()
                                  .getPassengerContactNumber),
                              trailing: IconButton(
                                  onPressed: () async {
                                    String driverContactNumber = context
                                        .read<UserProvider>()
                                        .getPassengerContactNumber;
                                    final _call = 'tel:$driverContactNumber';
                                    if (await canLaunch(_call)) {
                                      await launch(_call);
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.call,
                                    color: Colors.green,
                                  )),
                              subtitle: const Text(
                                'Contact Number',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 10),
                              ),
                            ),
                            const Text(
                              'To Pay',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              context.read<UserProvider>().getAmountToPay,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: col,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          instruction,
                          style: TextStyle(
                            color: col,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: ElevatedButton(
                        onPressed: () {
                          update();
                          setState(() {
                            instruction = 'Follow the Red Route';
                            col = Colors.red;
                            changePolyline();
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(22, 0, 22, 0),
                          child: Text(
                            'Passenger on Board',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w300,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1000.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: ElevatedButton(
                            onPressed: () {
                              update();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const MyHomePage()));
                            },
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: Text(
                                'Home Page',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(1000.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: ElevatedButton(
                            onPressed: () async {
                              bool result = await InternetConnectionChecker()
                                  .hasConnection;

                              if (result == true) {
                                book();
                                update();
                                DateTime datetime = DateTime.now();
                                String month =
                                    DateFormat.MMMM().format(datetime);
                                print(month);
                                String week =
                                    DateFormat.EEEE().format(datetime);
                                print(week);
                                String year = DateFormat.y().format(datetime);
                                print(year);

                                if (month == 'January') {
                                  FirebaseFirestore.instance
                                      .collection('sales')
                                      .doc('month')
                                      .update({
                                    month: myMonth +
                                        double.parse(context
                                            .read<UserProvider>()
                                            .amountToPay),
                                    'February': 0,
                                    'March': 0,
                                    'April': 0,
                                    'May': 0,
                                    'June': 0,
                                    'July': 0,
                                    'August': 0,
                                    'September': 0,
                                    'October': 0,
                                    'November': 0,
                                    'December': 0,
                                  });
                                } else {
                                  print('month - success');
                                  FirebaseFirestore.instance
                                      .collection('sales')
                                      .doc('month')
                                      .update({
                                    month: myMonth +
                                        double.parse(context
                                            .read<UserProvider>()
                                            .amountToPay),
                                  });
                                }

                                if (week == 'Monday') {
                                  FirebaseFirestore.instance
                                      .collection('sales')
                                      .doc('week')
                                      .update({
                                    week: myWeek +
                                        double.parse(context
                                            .read<UserProvider>()
                                            .amountToPay),
                                    'Tuesday': 0,
                                    'Wednesday': 0,
                                    'Thursday': 0,
                                    'Friday': 0,
                                    'Saturday': 0,
                                    'Sunday': 0,
                                  });
                                } else {
                                  print('week - success');
                                  FirebaseFirestore.instance
                                      .collection('sales')
                                      .doc('week')
                                      .update({
                                    week: myWeek +
                                        double.parse(context
                                            .read<UserProvider>()
                                            .amountToPay),
                                  });
                                }

                                FirebaseFirestore.instance
                                    .collection('sales')
                                    .doc('year')
                                    .update({
                                  year: myYear +
                                      double.parse(context
                                          .read<UserProvider>()
                                          .amountToPay),
                                });
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const MyHomePage()));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('No Internet Connection'),
                                  ),
                                );
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Text(
                                'End Ride',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(1000.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ]),
          ));
  }

  @override
  void dispose() {
    subscription.cancel();

    super.dispose();
  }
}
