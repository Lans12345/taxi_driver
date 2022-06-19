import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  late String username = '';
  late String password = '';
  late double latitude = 0;
  late double longitude = 0;
  late double pickUpLocationLatitude = 0;
  late double pickUpLocationLongitude = 0;
  late double destinationLocationLatitude = 0;
  late double destinationLocationLongitude = 0;
  late String passengerProfilePicture = '';
  late String passengerFirstName = '';
  late String passengerLastName = '';
  late String passengerContactNumber = '';
  late String amountToPay = '';
  late String destination = '';
  late String choice = '';
  late String time = '';
  late String date = '';

  String get getUsername => username;
  String get getPassword => password;
  String get getPassengerFirstName => passengerFirstName;
  String get getPassengerProfilePicture => passengerProfilePicture;
  String get getPassengerLastName => passengerLastName;
  String get getPassengerContactNumber => passengerContactNumber;
  String get getAmountToPay => amountToPay;
  String get getDestination => destination;
  String get getTime => time;
  String get getDate => date;
  String get getChoice => choice;
  double get getLatitude => latitude;
  double get getLongitude => longitude;

  double get getPickUpLocationLatitude => pickUpLocationLatitude;
  double get getPickUpLocationLongitude => pickUpLocationLongitude;
  double get getDestinationLocationLatitude => destinationLocationLatitude;

  double get getDestinationLocationLongitude => destinationLocationLongitude;

  void myPassengerFirstName(String firstName) {
    passengerFirstName = firstName;
    notifyListeners();
  }

  void myPassengerProfilePicture(String profilePicture) {
    passengerProfilePicture = profilePicture;
    notifyListeners();
  }

  void myPassengerLastName(String lastName) {
    passengerLastName = lastName;
    notifyListeners();
  }

  void myPassengerContactNumber(String contactNumber) {
    passengerContactNumber = contactNumber;
    notifyListeners();
  }

  void myAmountToPay(String myAmountToPay) {
    amountToPay = myAmountToPay;
    notifyListeners();
  }

  void myUserName(String userName) {
    username = userName;
    notifyListeners();
  }

  void myPassword(String passWord) {
    password = passWord;

    notifyListeners();
  }

  void myLatitude(double lat) {
    latitude = lat;

    notifyListeners();
  }

  void myLongitude(double long) {
    longitude = long;

    notifyListeners();
  }

  void myPickUpLocationLatitude(double lat) {
    pickUpLocationLatitude = lat;

    notifyListeners();
  }

  void myPickUpLocationLongitude(double long) {
    pickUpLocationLongitude = long;

    notifyListeners();
  }

  void myDestinationLocationLatitude(double lat) {
    destinationLocationLatitude = lat;

    notifyListeners();
  }

  void myDestinationLocationLongitude(double long) {
    destinationLocationLongitude = long;

    notifyListeners();
  }

  void myDestination(String des) {
    destination = des;

    notifyListeners();
  }

  void myChoice(String c) {
    choice = c;

    notifyListeners();
  }

  void myDate(String d) {
    date = d;

    notifyListeners();
  }

  void myTime(String t) {
    time = t;

    notifyListeners();
  }
}
