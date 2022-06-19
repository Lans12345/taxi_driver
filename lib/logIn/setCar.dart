import 'dart:io';
import 'package:drive/home/homePage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SetCar extends StatefulWidget {
  const SetCar({Key? key}) : super(key: key);

  @override
  State<SetCar> createState() => _SetCarState();
}

class _SetCarState extends State<SetCar> {
  @override
  void initState() {
    super.initState();
    getData();
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

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  late String fileName = '';
  late File imageFile;

  late String imageURL = '';

  late String uploadStatus = 'Not Uploaded';

  late String profile = 'https://cdn-icons-png.flaticon.com/512/67/67994.png';

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

  late String carModel = '';
  late String carPlateNumber = '';
  late String carPicture = '';

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
                    backgroundColor: Colors.white,
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
                'Car Model',
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
                    carModel = _input;
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
              const SizedBox(height: 20),
              const Text(
                'Plate Number',
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
                    carPlateNumber = _input;
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
                    bool result =
                        await InternetConnectionChecker().hasConnection;

                    if (result == true) {
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setBool('setProfile', true);
                      prefs.setString('carModel', carModel);
                      prefs.setString('carPicture', imageURL);

                      prefs.setString('carPlateNumber', carPlateNumber);
                      FirebaseFirestore.instance
                          .collection('driver')
                          .doc('$getUserName-$getPassword')
                          .update({
                        'carPicture': imageURL,
                        'carModel': carModel,
                        'carPlateNumber': carPlateNumber,
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
