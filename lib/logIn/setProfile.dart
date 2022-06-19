import 'dart:io';
import 'package:drive/logIn/setCar.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SetProfile extends StatefulWidget {
  const SetProfile({Key? key}) : super(key: key);

  @override
  State<SetProfile> createState() => _SetProfileState();
}

class _SetProfileState extends State<SetProfile> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  late String firstName = '';
  late String lastName = '';
  late String contactNumber = '';
  late String email = '';
  late String barangay = '';
  late String address = '';
  late String city = '';

  late String getUserName = '';
  late String getPassword = '';

  getData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      getUserName = prefs.getString('username')!;
      getPassword = prefs.getString('password')!;
    });
  }

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  late String fileName = '';
  late File imageFile;

  late String imageURL = '';

  late String uploadStatus = 'Not Uploaded';

  late String profile = 'https://cdn-icons-png.flaticon.com/512/149/149071.png';

  Future<void> _upload(String inputSource) async {
    final picker = ImagePicker();
    XFile pickedImage;
    try {
      pickedImage = (await picker.pickImage(
          source: inputSource == 'camera'
              ? ImageSource.camera
              : ImageSource.gallery,
          maxWidth: 1920))!;

      fileName = path.basename(pickedImage.path);
      imageFile = File(pickedImage.path);

      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const Padding(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: AlertDialog(
                title: Text(
              '         Loading . . .',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Quicksand'),
            )),
          ),
        );

        await firebase_storage.FirebaseStorage.instance
            .ref(fileName)
            .putFile(imageFile);
        imageURL = await firebase_storage.FirebaseStorage.instance
            .ref(fileName)
            .getDownloadURL();

        setState(() {
          profile = imageURL;
          uploadStatus = 'Uploaded Succesfully';
        });

        Navigator.of(context).pop();
      } on firebase_storage.FirebaseException catch (error) {
        if (kDebugMode) {
          print(error);
        }
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Users Profile',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 30, top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: InkWell(
                  onTap: () {
                    _upload('gallery');
                  },
                  child: CircleAvatar(
                    minRadius: 50,
                    maxRadius: 50,
                    backgroundImage: NetworkImage(profile),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 75, left: 60),
                      child:
                          Icon(Icons.add_a_photo_rounded, color: Colors.black),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'First Name',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Quicksand',
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                child: TextFormField(
                  textCapitalization: TextCapitalization.words,
                  style: const TextStyle(
                      color: Colors.grey, fontFamily: 'Quicksand'),
                  onChanged: (_input) {
                    firstName = _input;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.white),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.white),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 0,
                  right: 30,
                  top: 0,
                  bottom: 0,
                ),
                child: Divider(
                  color: Colors.grey,
                ),
              ),
              const Text(
                'Last Name',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Quicksand',
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                child: TextFormField(
                  textCapitalization: TextCapitalization.words,
                  style: const TextStyle(
                      color: Colors.grey, fontFamily: 'Quicksand'),
                  onChanged: (_input) {
                    lastName = _input;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.white),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.white),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 0,
                  right: 30,
                  top: 0,
                  bottom: 0,
                ),
                child: Divider(
                  color: Colors.grey,
                ),
              ),
              const Text(
                'Contact Number',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Quicksand',
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                child: TextFormField(
                  maxLength: 11,
                  keyboardType: TextInputType.number,
                  textCapitalization: TextCapitalization.words,
                  style: const TextStyle(
                      color: Colors.grey, fontFamily: 'Quicksand'),
                  onChanged: (_input) {
                    contactNumber = _input;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.white),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.white),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 0,
                  right: 30,
                  top: 0,
                  bottom: 0,
                ),
                child: Divider(
                  color: Colors.grey,
                ),
              ),
              const Text(
                'Address',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                child: TextFormField(
                  textCapitalization: TextCapitalization.words,
                  style: const TextStyle(
                      color: Colors.grey, fontFamily: 'Quicksand'),
                  onChanged: (_input) {
                    address = _input;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.white),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.white),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 0,
                  right: 30,
                  top: 0,
                  bottom: 0,
                ),
                child: Divider(
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 30),
                child: ElevatedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    bool result =
                        await InternetConnectionChecker().hasConnection;

                    if (result == true) {
                      prefs.setString('driverName', firstName + ' ' + lastName);
                      prefs.setString('driverContactNumber', contactNumber);
                      prefs.setString('profilePicture', imageURL);
                      FirebaseFirestore.instance
                          .collection('driver')
                          .doc('$getUserName-$getPassword')
                          .update({
                        'firstName': firstName,
                        'lastName': lastName,
                        'contactNumber': contactNumber,
                        'address': address,
                        'profilePicture': imageURL,
                      });

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SetCar()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('No Internet Connection'),
                        ),
                      );
                    }
                  },
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Continue',
                            style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ]),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
