import 'package:flutter/material.dart';

import '../home/HomePage.dart';
import '../profile/profile.dart';
import 'hotline.dart';

class Operator extends StatelessWidget {
  const Operator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          'Operator',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 24.0, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            height: 700,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('lib/images/background.JPG'),
                    fit: BoxFit.fill)),
            child: Container(
              color: Colors.black54,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Image(
                    fit: BoxFit.contain,
                    width: 120,
                    image: AssetImage('lib/images/logo.png'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Ilocos Transport Cooperative',
                    style: TextStyle(
                        fontFamily: 'Quicksand',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    'Operator',
                    style: TextStyle(
                        fontFamily: 'Quicksand',
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 12.0),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 20, right: 10),
                    child: Text(
                      'Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description',
                      style: TextStyle(
                          fontFamily: 'Quicksand',
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 14.0),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                          color: Colors.white,
                          child: const ExpansionTile(
                            leading:
                                Icon(Icons.contact_mail, color: Colors.grey),
                            title: Text(
                              'Contact Details',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Quicksand',
                                fontSize: 18.0,
                              ),
                            ),
                            children: [
                              ListTile(
                                subtitle: Text(
                                  'Email',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'Quicksand',
                                    fontSize: 10.0,
                                  ),
                                ),
                                title: Text(
                                  'ilocostransport@gmail.com',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Quicksand',
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                              ListTile(
                                subtitle: Text(
                                  'Contact Number',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'Quicksand',
                                    fontSize: 10.0,
                                  ),
                                ),
                                title: Text(
                                  '09090104355',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Quicksand',
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  const Text(
                    'All Right Reserved',
                    style: TextStyle(
                        fontFamily: 'Quicksand',
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 10.0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
