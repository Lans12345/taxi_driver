import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import '../loadingScreen/loadingScreen2.dart';
import '../provider/userCredentialsProvider.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  @override
  void initState() {
    super.initState();
    getData();
    _determinePosition();
    getLocation();
  }

  late String getUserName = '';
  late String getPassword = '';

  getData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      getUserName = prefs.getString('username')!;
      getPassword = prefs.getString('password')!;
    });
  }

  late String username = '';
  late String password = '';

  late String userNameSignUp = '';

  late String passwordSignUp = '';
  late String confirmPasswordSignUp = '';

  final geo = GeoFlutterFire();

  Future signUp() async {
    final docUser = FirebaseFirestore.instance
        .collection('driver')
        .doc('$userNameSignUp-$passwordSignUp');

    final json = {
      'firstName': '',
      'lastName': '',
      'contactNumber': '',
      'address': '',
      'username': userNameSignUp,
      'password': passwordSignUp,
      'profilePicture': '',
      'status': 'driver',
      'rating': 4.5,
      'carPicture': '',
      'carModel': '',
      'carPlateNumber': '',
      'latitude': 0.00,
      'longitude': 0.00,
    };

    await docUser.set(json);
  }

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

  late double lat = 0;
  late double long = 0;

  getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      lat = position.latitude;
      long = position.longitude;
    });
  }

  late String myUserName = '';

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
                image: AssetImage("lib/images/background.JPG"),
                opacity: 175.0,
                fit: BoxFit.cover),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 60,
              ),
              const Image(
                fit: BoxFit.contain,
                height: 100,
                image: AssetImage('lib/images/logo.png'),
              ),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                        height: 300,
                        width: 300,
                        color: Colors.red,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: TextFormField(
                                textCapitalization: TextCapitalization.words,
                                style: const TextStyle(
                                    color: Colors.red, fontFamily: 'Quicksand'),
                                onChanged: (_input) {
                                  username = _input;
                                },
                                decoration: InputDecoration(
                                  suffixIcon: const Icon(
                                    Icons.person,
                                    size: 28.0,
                                    color: Colors.red,
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1, color: Colors.white),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1, color: Colors.white),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  hintText: 'Username',
                                  hintStyle: const TextStyle(
                                    fontFamily: 'Quicksand',
                                    color: Colors.red,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: TextFormField(
                                obscureText: true,
                                style: const TextStyle(
                                    color: Colors.red, fontFamily: 'Quicksand'),
                                onChanged: (_input) {
                                  password = _input;
                                },
                                decoration: InputDecoration(
                                  suffixIcon: const Icon(
                                    Icons.remove_red_eye_rounded,
                                    size: 28.0,
                                    color: Colors.red,
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1, color: Colors.white),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1, color: Colors.white),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  hintText: 'Password',
                                  hintStyle: const TextStyle(
                                    fontFamily: 'Quicksand',
                                    color: Colors.red,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (username == getUserName &&
                                      password == getPassword) {
                                    context
                                        .read<UserProvider>()
                                        .myUserName(username);
                                    context
                                        .read<UserProvider>()
                                        .myPassword(password);

                                    FirebaseFirestore.instance
                                        .collection('driver')
                                        .doc(username + '-' + password)
                                        .update({
                                      'latitude': lat,
                                      'longitude': long,
                                    });

                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoadingScreen2()));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Invalid Account'),
                                      ),
                                    );
                                  }
                                },
                                child: const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                                  child: Text(
                                    'Log In',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 24.0,
                                    ),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20, left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) => SizedBox(
                                                height: 50,
                                                child: AlertDialog(
                                                  backgroundColor:
                                                      Colors.grey[100],
                                                  content: SizedBox(
                                                    height: 350,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 0,
                                                              right: 0),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .stretch,
                                                          children: [
                                                            const SizedBox(
                                                              height: 30,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      10,
                                                                      0,
                                                                      10,
                                                                      0),
                                                              child:
                                                                  TextFormField(
                                                                textCapitalization:
                                                                    TextCapitalization
                                                                        .words,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontFamily:
                                                                        'Quicksand'),
                                                                onChanged:
                                                                    (_userName) {
                                                                  userNameSignUp =
                                                                      _userName;
                                                                },
                                                                decoration:
                                                                    InputDecoration(
                                                                  suffixIcon:
                                                                      const Icon(
                                                                    Icons
                                                                        .person,
                                                                    size: 28.0,
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                  fillColor:
                                                                      Colors
                                                                          .white,
                                                                  filled: true,
                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide: const BorderSide(
                                                                        width:
                                                                            1,
                                                                        color: Colors
                                                                            .white),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                  ),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide: const BorderSide(
                                                                        width:
                                                                            1,
                                                                        color: Colors
                                                                            .white),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                  ),
                                                                  hintText:
                                                                      'Username',
                                                                  hintStyle:
                                                                      const TextStyle(
                                                                    fontFamily:
                                                                        'Quicksand',
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        12.0,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      10,
                                                                      0,
                                                                      10,
                                                                      0),
                                                              child:
                                                                  TextFormField(
                                                                obscureText:
                                                                    true,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontFamily:
                                                                        'Quicksand'),
                                                                onChanged:
                                                                    (_userName) {
                                                                  passwordSignUp =
                                                                      _userName;
                                                                },
                                                                decoration:
                                                                    InputDecoration(
                                                                  suffixIcon:
                                                                      const Icon(
                                                                    Icons
                                                                        .remove_red_eye_rounded,
                                                                    size: 28.0,
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                  fillColor:
                                                                      Colors
                                                                          .white,
                                                                  filled: true,
                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide: const BorderSide(
                                                                        width:
                                                                            1,
                                                                        color: Colors
                                                                            .white),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                  ),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide: const BorderSide(
                                                                        width:
                                                                            1,
                                                                        color: Colors
                                                                            .white),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                  ),
                                                                  hintText:
                                                                      'Password',
                                                                  hintStyle:
                                                                      const TextStyle(
                                                                    fontFamily:
                                                                        'Quicksand',
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        12.0,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      10,
                                                                      0,
                                                                      10,
                                                                      0),
                                                              child:
                                                                  TextFormField(
                                                                obscureText:
                                                                    true,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontFamily:
                                                                        'Quicksand'),
                                                                onChanged:
                                                                    (_userName) {
                                                                  confirmPasswordSignUp =
                                                                      _userName;
                                                                },
                                                                decoration:
                                                                    InputDecoration(
                                                                  suffixIcon:
                                                                      const Icon(
                                                                    Icons
                                                                        .remove_red_eye_rounded,
                                                                    size: 28.0,
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                  fillColor:
                                                                      Colors
                                                                          .white,
                                                                  filled: true,
                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide: const BorderSide(
                                                                        width:
                                                                            1,
                                                                        color: Colors
                                                                            .white),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                  ),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide: const BorderSide(
                                                                        width:
                                                                            1,
                                                                        color: Colors
                                                                            .white),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                  ),
                                                                  hintText:
                                                                      'Confirm Password',
                                                                  hintStyle:
                                                                      const TextStyle(
                                                                    fontFamily:
                                                                        'Quicksand',
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        12.0,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 25,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      10,
                                                                      0,
                                                                      10,
                                                                      0),
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed:
                                                                    () async {
                                                                  bool result =
                                                                      await InternetConnectionChecker()
                                                                          .hasConnection;
                                                                  if (result ==
                                                                      true) {
                                                                    if (userNameSignUp == '' &&
                                                                        passwordSignUp ==
                                                                            '' &&
                                                                        confirmPasswordSignUp ==
                                                                            '') {
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                        const SnackBar(
                                                                          content:
                                                                              Text('Invalid'),
                                                                        ),
                                                                      );
                                                                    } else {
                                                                      if (confirmPasswordSignUp ==
                                                                          passwordSignUp) {
                                                                        // Provider

                                                                        final prefs =
                                                                            await SharedPreferences.getInstance();

                                                                        prefs.setString(
                                                                            'username',
                                                                            userNameSignUp);
                                                                        prefs.setString(
                                                                            'password',
                                                                            passwordSignUp);

                                                                        CoolAlert.show(
                                                                            barrierDismissible: false,
                                                                            confirmBtnColor: Colors.red,
                                                                            confirmBtnTextStyle: const TextStyle(
                                                                              fontFamily: 'Quicksand',
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.white,
                                                                            ),
                                                                            context: context,
                                                                            type: CoolAlertType.success,
                                                                            text: 'Account Created successfully!',
                                                                            onConfirmBtnTap: () async {
                                                                              final prefs = await SharedPreferences.getInstance();
                                                                              prefs.setBool('setProfile', false);
                                                                              context.read<UserProvider>().myUserName(userNameSignUp);
                                                                              context.read<UserProvider>().myPassword(passwordSignUp);
                                                                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LogInPage()));
                                                                            },
                                                                            confirmBtnText: 'Continue');

                                                                        signUp();
                                                                      } else {
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(
                                                                          const SnackBar(
                                                                            content:
                                                                                Text('Invalid Password'),
                                                                          ),
                                                                        );
                                                                      }
                                                                    }
                                                                  } else {
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                      const SnackBar(
                                                                        content:
                                                                            Text('No Internet Connection'),
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                                child:
                                                                    const Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          0,
                                                                          15,
                                                                          0,
                                                                          15),
                                                                  child: Text(
                                                                    'Sign Up',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .red,
                                                                      fontSize:
                                                                          24.0,
                                                                    ),
                                                                  ),
                                                                ),
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  primary: Colors
                                                                      .white,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5.0),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ));
                                    },
                                    child: const Text(
                                      'Create Account',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) => SizedBox(
                                                height: 50,
                                                child: AlertDialog(
                                                  backgroundColor:
                                                      Colors.grey[100],
                                                  content: SizedBox(
                                                    height: 180,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 0,
                                                              right: 0),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .stretch,
                                                          children: [
                                                            const SizedBox(
                                                              height: 30,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      10,
                                                                      0,
                                                                      10,
                                                                      0),
                                                              child:
                                                                  TextFormField(
                                                                textCapitalization:
                                                                    TextCapitalization
                                                                        .words,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontFamily:
                                                                        'Quicksand'),
                                                                onChanged:
                                                                    (_input) {
                                                                  myUserName =
                                                                      _input;
                                                                },
                                                                decoration:
                                                                    InputDecoration(
                                                                  suffixIcon:
                                                                      const Icon(
                                                                    Icons
                                                                        .person,
                                                                    size: 28.0,
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                  fillColor:
                                                                      Colors
                                                                          .white,
                                                                  filled: true,
                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide: const BorderSide(
                                                                        width:
                                                                            1,
                                                                        color: Colors
                                                                            .white),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                  ),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide: const BorderSide(
                                                                        width:
                                                                            1,
                                                                        color: Colors
                                                                            .white),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                  ),
                                                                  hintText:
                                                                      'Username',
                                                                  hintStyle:
                                                                      const TextStyle(
                                                                    fontFamily:
                                                                        'Quicksand',
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        12.0,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      20,
                                                                      20,
                                                                      20,
                                                                      0),
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed:
                                                                    () async {
                                                                  final prefs =
                                                                      await SharedPreferences
                                                                          .getInstance();
                                                                  if (myUserName ==
                                                                      prefs.getString(
                                                                          'username')!) {
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        builder: (context) =>
                                                                            AlertDialog(
                                                                              title: Text(
                                                                                'Your password: ' + prefs.getString('password')!,
                                                                                style: const TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold),
                                                                              ),
                                                                              actions: <Widget>[
                                                                                FlatButton(
                                                                                  onPressed: () {
                                                                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LogInPage()));
                                                                                  },
                                                                                  child: const Text(
                                                                                    'Continue',
                                                                                    style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ));
                                                                  } else {
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                      const SnackBar(
                                                                        content:
                                                                            Text('Invalid Username'),
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                                child:
                                                                    const Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          0,
                                                                          15,
                                                                          0,
                                                                          15),
                                                                  child: Text(
                                                                      'Continue',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .red,
                                                                        fontSize:
                                                                            24.0,
                                                                      )),
                                                                ),
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  primary: Colors
                                                                      .white,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5.0),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ));
                                    },
                                    child: const Text(
                                      'Forgot password?',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
