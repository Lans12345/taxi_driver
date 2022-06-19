import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive/maps/bookingMap.dart';
import 'package:drive/pages/hotline.dart';
import 'package:drive/pages/operator.dart';
import 'package:drive/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../provider/userCredentialsProvider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  late double lat = 0.0;
  late double long = 0.0;

  final geo = GeoFlutterFire();

  getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      lat = position.latitude;
      long = position.longitude;
    });

    FirebaseFirestore.instance
        .collection('driver')
        .doc(
            '${context.read<UserProvider>().getUsername}-${context.read<UserProvider>().getPassword}')
        .update({
      'latitude': lat,
      'longitude': long,
    });
  }

  @override
  void initState() {
    super.initState();
    _determinePosition();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'Bookings',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32.0,
                color: Colors.white),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 0),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const Profile()));
                },
                icon: const Icon(
                  Icons.person,
                  size: 32.0,
                  color: Colors.white,
                ),
              ),
            ),
            PopupMenuButton(
                iconSize: 28,
                itemBuilder: (context) => [
                      PopupMenuItem(
                        onTap: () async {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const Hotline()));
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const Hotline()));
                        },
                        child: const Text("Hotlines"),
                        value: 1,
                      ),
                      PopupMenuItem(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const Operator()));
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const Operator()));
                        },
                        child: const Text("Operator"),
                        value: 2,
                      ),
                    ]),
          ],
          bottom: const TabBar(
            labelColor: Colors.white,
            labelStyle: TextStyle(
              fontWeight: FontWeight.w300,
            ),
            tabs: [
              Tab(
                text: "Todays Booking",
              ),
              Tab(
                text: "Scheduled Booking",
              ),
            ],
            indicatorColor: Colors.white,
            indicatorWeight: 2,
          ),
        ),
        body: TabBarView(
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('driver')
                    .where('bookingType', isEqualTo: 'instantBooking')
                    .where('username',
                        isEqualTo: context.read<UserProvider>().getUsername)
                    .where('password',
                        isEqualTo: context.read<UserProvider>().getPassword)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    print('error');
                    return const Center(child: Text('Error'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    print('waiting');
                    return const Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Center(
                          child: CircularProgressIndicator(
                        color: Colors.black,
                      )),
                    );
                  }

                  final data = snapshot.requireData;
                  return SizedBox(
                    child: ListView.builder(
                        itemCount: snapshot.data?.size ?? 0,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      minRadius: 40,
                                      maxRadius: 40,
                                      backgroundImage: NetworkImage(
                                          data.docs[index]['profilePicture']),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          data.docs[index]['name'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 14),
                                        ),
                                        Text(
                                          data.docs[index]['userContactNumber'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w300,
                                              color: Colors.grey,
                                              fontSize: 10),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.green,
                                        ),
                                      ),
                                      child: IconButton(
                                        onPressed: () async {
                                          final prefs = await SharedPreferences
                                              .getInstance();

                                          setState(() {
                                            prefs.setString('date',
                                                data.docs[index]['date']);
                                            prefs.setString('time',
                                                data.docs[index]['time']);
                                            prefs.setString(
                                                'destination',
                                                data.docs[index]
                                                    ['destination']);
                                          });
                                          context
                                              .read<UserProvider>()
                                              .myPassengerProfilePicture(
                                                  data.docs[index]
                                                      ['profilePicture']);

                                          context
                                              .read<UserProvider>()
                                              .myDate(data.docs[index]['date']);
                                          context
                                              .read<UserProvider>()
                                              .myTime(data.docs[index]['time']);

                                          context
                                              .read<UserProvider>()
                                              .myDestination(data.docs[index]
                                                  ['destination']);

                                          context
                                              .read<UserProvider>()
                                              .myPassengerLastName(
                                                  data.docs[index]['name']);

                                          context
                                              .read<UserProvider>()
                                              .myPassengerContactNumber(
                                                  data.docs[index]
                                                      ['userContactNumber']);

                                          context
                                              .read<UserProvider>()
                                              .myAmountToPay(data.docs[index]
                                                  ['amountPaid']);

                                          context
                                              .read<UserProvider>()
                                              .myPickUpLocationLatitude(data
                                                  .docs[index]['locationLat']);

                                          context
                                              .read<UserProvider>()
                                              .myPickUpLocationLongitude(data
                                                  .docs[index]['locationLong']);

                                          context
                                              .read<UserProvider>()
                                              .myDestinationLocationLatitude(
                                                  data.docs[index]
                                                      ['destinationLat']);

                                          context
                                              .read<UserProvider>()
                                              .myDestinationLocationLongitude(
                                                  data.docs[index]
                                                      ['destinationLong']);

                                          context
                                              .read<UserProvider>()
                                              .myChoice('instantBooking');

                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const BookingMap()));
                                        },
                                        icon: const Icon(
                                          Icons.check,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    /*
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.red,
                                        ),
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          print(context
                                              .read<UserProvider>()
                                              .getPassword);
                                          print(context
                                              .read<UserProvider>()
                                              .getUsername);
                                        },
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.red,
                                        ),
                                      ),
                                    )
                                    */
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  );
                }),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('driver')
                    .where('username',
                        isEqualTo: context.read<UserProvider>().getUsername)
                    .where('password',
                        isEqualTo: context.read<UserProvider>().getPassword)
                    .where('bookingType', isEqualTo: 'advanceBooking')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    print('error');
                    return const Center(child: Text('Error'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    print('waiting');
                    return const Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Center(
                          child: CircularProgressIndicator(
                        color: Colors.black,
                      )),
                    );
                  }

                  final data = snapshot.requireData;
                  return SizedBox(
                    child: ListView.builder(
                        itemCount: snapshot.data?.size ?? 0,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                    barrierDismissible: true,
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          backgroundColor: Colors.grey[100],
                                          content: SizedBox(
                                            height: 230,
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Column(
                                                          children: [
                                                            const Text(
                                                              'TICKET',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Quicksand',
                                                                  color: Colors
                                                                      .green,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            const Text(
                                                              'Pick up date and time',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Quicksand',
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 8,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300),
                                                            ),
                                                            const SizedBox(
                                                              height: 3,
                                                            ),
                                                            Text(
                                                              data.docs[index]
                                                                      ['date'] +
                                                                  ' - ' +
                                                                  data.docs[
                                                                          index]
                                                                      ['time'],
                                                              style: const TextStyle(
                                                                  fontFamily:
                                                                      'Quicksand',
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ],
                                                        ),
                                                      ]),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(children: [
                                                    const Text(
                                                      'Passenger:',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Quicksand',
                                                          fontSize: 10.0,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      data.docs[index]['name'],
                                                      style: const TextStyle(
                                                          fontFamily:
                                                              'Quicksand',
                                                          fontSize: 12.0,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ]),
                                                  Row(children: [
                                                    const Text(
                                                      'Number Of Passengers',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Quicksand',
                                                          fontSize: 10.0,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      data.docs[index][
                                                              'numberOfPassengers']
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontFamily:
                                                              'Quicksand',
                                                          fontSize: 12.0,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ]),
                                                  Text(
                                                    'Pick Up Place: ' +
                                                        data.docs[index]
                                                            ['location'],
                                                    style: const TextStyle(
                                                        fontFamily: 'Quicksand',
                                                        color: Colors.black,
                                                        fontSize: 10.0,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                  Text(
                                                    'Destination Place: ' +
                                                        data.docs[index]
                                                            ['destination'],
                                                    style: const TextStyle(
                                                        fontFamily: 'Quicksand',
                                                        color: Colors.black,
                                                        fontSize: 10.0,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Text(
                                                          'Amount to Pay:',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Quicksand',
                                                              fontSize: 10.0,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          data.docs[index]
                                                              ['amountPaid'],
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  'Quicksand',
                                                              fontSize: 16.0,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ]),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: const [
                                                        Text(
                                                          'Tesla Motors Inc.',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Quicksand',
                                                              fontSize: 8.0,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300),
                                                        ),
                                                      ]),
                                                ]),
                                          ),
                                          actions: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          5, 0, 5, 0),
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      String
                                                          driverContactNumber =
                                                          data.docs[index][
                                                              'userContactNumber'];
                                                      final _call =
                                                          'tel:$driverContactNumber';
                                                      if (await canLaunch(
                                                          _call)) {
                                                        await launch(_call);
                                                      }
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(0, 0, 0, 0),
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: const [
                                                            Text(
                                                              'Call Passenger',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      12.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                          ]),
                                                    ),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary: Colors.white,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(0.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          5, 0, 5, 0),
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      final prefs =
                                                          await SharedPreferences
                                                              .getInstance();

                                                      setState(() {
                                                        prefs.setString(
                                                            'date',
                                                            data.docs[index]
                                                                ['date']);
                                                        prefs.setString(
                                                            'time',
                                                            data.docs[index]
                                                                ['time']);
                                                        prefs.setString(
                                                            'destination',
                                                            data.docs[index][
                                                                'destination']);
                                                      });
                                                      context
                                                          .read<UserProvider>()
                                                          .myPassengerProfilePicture(
                                                              data.docs[index][
                                                                  'profilePicture']);

                                                      context
                                                          .read<UserProvider>()
                                                          .myDestination(data
                                                                  .docs[index]
                                                              ['destination']);

                                                      context
                                                          .read<UserProvider>()
                                                          .myPassengerLastName(
                                                              data.docs[index]
                                                                  ['name']);

                                                      context
                                                          .read<UserProvider>()
                                                          .myPassengerContactNumber(
                                                              data.docs[index][
                                                                  'userContactNumber']);

                                                      context
                                                          .read<UserProvider>()
                                                          .myAmountToPay(data
                                                                  .docs[index]
                                                              ['amountPaid']);

                                                      context
                                                          .read<UserProvider>()
                                                          .myPickUpLocationLatitude(
                                                              data.docs[index][
                                                                  'locationLat']);

                                                      context
                                                          .read<UserProvider>()
                                                          .myPickUpLocationLongitude(
                                                              data.docs[index][
                                                                  'locationLong']);

                                                      context
                                                          .read<UserProvider>()
                                                          .myDestinationLocationLatitude(
                                                              data.docs[index][
                                                                  'destinationLat']);

                                                      context
                                                          .read<UserProvider>()
                                                          .myDestinationLocationLongitude(
                                                              data.docs[index][
                                                                  'destinationLong']);

                                                      context
                                                          .read<UserProvider>()
                                                          .myChoice(
                                                              'advanceBooking');

                                                      context
                                                          .read<UserProvider>()
                                                          .myDate(
                                                              data.docs[index]
                                                                  ['date']);
                                                      context
                                                          .read<UserProvider>()
                                                          .myTime(
                                                              data.docs[index]
                                                                  ['time']);
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const BookingMap()));
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(0, 0, 0, 0),
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: const [
                                                            Text(
                                                              'See on Map',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      12.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                          ]),
                                                    ),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary: Colors.white,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(0.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        minRadius: 40,
                                        maxRadius: 40,
                                        backgroundImage: NetworkImage(
                                            data.docs[index]['profilePicture']),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            data.docs[index]['date'] +
                                                ' - ' +
                                                data.docs[index]['time'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w300,
                                                color: Colors.grey,
                                                fontSize: 10),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            data.docs[index]['name'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 14),
                                          ),
                                          Text(
                                            data.docs[index]
                                                ['userContactNumber'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w300,
                                                color: Colors.grey,
                                                fontSize: 10),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
