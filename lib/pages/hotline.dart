import 'package:flutter/material.dart';

class Hotline extends StatelessWidget {
  const Hotline({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          'Hotlines',
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: Colors.black54,
                height: 700,
                child: Column(
                  children: const [
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      '09090104355',
                      style: TextStyle(
                          fontFamily: 'Quicksand',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0),
                    ),
                    Text(
                      'SCiVER IT Solutions',
                      style: TextStyle(
                          fontFamily: 'Quicksand',
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0),
                    ),
                    Text(
                      'Developer',
                      style: TextStyle(
                          fontFamily: 'Quicksand',
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 10.0),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      '09090104355',
                      style: TextStyle(
                          fontFamily: 'Quicksand',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0),
                    ),
                    Text(
                      'Ilocos Transport Cooperative',
                      style: TextStyle(
                          fontFamily: 'Quicksand',
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0),
                    ),
                    Text(
                      'Operator',
                      style: TextStyle(
                          fontFamily: 'Quicksand',
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 10.0),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      '09090104355',
                      style: TextStyle(
                          fontFamily: 'Quicksand',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0),
                    ),
                    Text(
                      'Ilocos Police Hotline',
                      style: TextStyle(
                          fontFamily: 'Quicksand',
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      '09090104355',
                      style: TextStyle(
                          fontFamily: 'Quicksand',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0),
                    ),
                    Text(
                      'Ilocos Ambulance Hotline',
                      style: TextStyle(
                          fontFamily: 'Quicksand',
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
