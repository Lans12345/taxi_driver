import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive/logIn/setProfile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/userCredentialsProvider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  late String firstName = '';
  late String lastName = '';
  late String contactNumber = '';
  late String address = '';
  late String carModel = '';
  late String plateNumber = '';
  // Fields nga Wala pa
  late double rating = 0;
  late String profilePicture = '';
  late String carPicture = '';

  late String password = '';

  getData() async {
    // Use provider
    var collection = FirebaseFirestore.instance
        .collection('driver')
        .where('username', isEqualTo: context.read<UserProvider>().getUsername)
        .where('password', isEqualTo: context.read<UserProvider>().getPassword)
        .where('status', isEqualTo: 'driver');

    var querySnapshot = await collection.get();
    setState(() {
      for (var queryDocumentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = queryDocumentSnapshot.data();
        firstName = data['firstName'];
        lastName = data['lastName'];
        contactNumber = data['contactNumber'];
        address = data['address'];
        carModel = data['carModel'];
        plateNumber = data['carPlateNumber'];
        profilePicture = data['profilePicture'];
        rating = data['rating'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (profilePicture == '') {
      profilePicture = 'https://cdn-icons-png.flaticon.com/512/149/149071.png';
    }
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text(
            'Profile',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            Center(
              child: CircleAvatar(
                minRadius: 40,
                maxRadius: 40,
                backgroundImage: NetworkImage(profilePicture),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              '$firstName $lastName',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 18),
            ),
            const SizedBox(
              height: 3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(
                  color: Colors.amber,
                  fit: BoxFit.contain,
                  width: 12,
                  image: AssetImage('lib/images/star.png'),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  rating.toString(),
                  style: const TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                print(context.read<UserProvider>().getUsername);
                print(context.read<UserProvider>().getPassword);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SetProfile()));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.bold,
                        fontSize: 10.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 10, 50, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: const SizedBox(
                  height: 30,
                  child: TabBar(
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.black,
                    labelStyle: TextStyle(
                      fontFamily: 'Quicksand',
                    ),
                    tabs: [
                      Tab(
                        text: 'Details',
                      ),
                      Tab(
                        text: 'History',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                child: TabBarView(children: [
                  ListView(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Center(
                            child: ListTile(
                              leading: const Icon(
                                Icons.call,
                                color: Colors.green,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              tileColor: Colors.white,
                              title: Text(
                                contactNumber,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
                                    fontSize: 18),
                              ),
                              subtitle: const Text(
                                'Contact Number',
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.grey,
                                    fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 10),
                          child: Center(
                            child: ListTile(
                              leading: const Icon(
                                Icons.location_on_rounded,
                                color: Colors.green,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              tileColor: Colors.white,
                              title: Text(
                                address,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
                                    fontSize: 18),
                              ),
                              subtitle: const Text(
                                'Address',
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.grey,
                                    fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 10),
                          child: Center(
                            child: ListTile(
                              leading: const Icon(
                                Icons.local_taxi_rounded,
                                color: Colors.green,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              tileColor: Colors.white,
                              title: Text(
                                carModel,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
                                    fontSize: 18),
                              ),
                              subtitle: const Text(
                                'Car Model',
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.grey,
                                    fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 10),
                          child: Center(
                            child: ListTile(
                              leading: const Icon(
                                Icons.format_list_numbered,
                                color: Colors.green,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              tileColor: Colors.white,
                              title: Text(
                                plateNumber,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
                                    fontSize: 18),
                              ),
                              subtitle: const Text(
                                'Plate Number',
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.grey,
                                    fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('driver')
                          .where('type', isEqualTo: 'history')
                          .where('password',
                              isEqualTo:
                                  context.read<UserProvider>().getPassword)
                          .where('username',
                              isEqualTo:
                                  context.read<UserProvider>().getUsername)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          print('error');
                          return const Center(child: Text('Error'));
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                                return Column(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 40, right: 40, top: 10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: ListTile(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        leading: const Icon(
                                          Icons.my_location_rounded,
                                          color: Colors.green,
                                        ),
                                        tileColor: Colors.white,
                                        title: Text(data.docs[index]
                                                ['destination'] +
                                            " - " +
                                            data.docs[index]['date'] +
                                            ' - ' +
                                            data.docs[index]['time'] +
                                            ' sec'),
                                        subtitle: Text(
                                          "Passenger: " +
                                              data.docs[index]['passengerName'],
                                          style: const TextStyle(
                                            fontSize: 10.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]);
                              }),
                        );
                      }),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
