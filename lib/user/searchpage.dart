import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devu/about.dart';
import 'package:devu/firebase/auth_services.dart';
import 'package:devu/loginandsignup/login.dart';
import 'package:devu/user/editprofileuser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String email = "";
  String name = "";
  String fieldname = "";
  String Location = "";
  String facilities = "";
  String capacity = "";
  String rentalCharge = "";
  String phone = "";
  String address = "";
  String image = "";
  final storage = FirebaseStorage.instance;

  getdata() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      image = (snap.data() as Map<String, dynamic>)['imageLink'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getname();
    getdata();
  }

  getname() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      email = (snap.data() as Map<String, dynamic>)['email'];
      name = (snap.data() as Map<String, dynamic>)['username'];

      phone = (snap.data() as Map<String, dynamic>)['phone'];
    });
  }

  bool isSearching = false;
  List<String> nameCheck = [];
  List<String> nameList = [];
  final TextEditingController _textEditingController = TextEditingController();

  final List<String> _dataList = [];
  final List<String> _searchResult = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 60,
          backgroundColor: Colors.black,
          title: !isSearching
              ? Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Row(
                    children: const [
                      Text(
                        'ARENA',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ],
                  ),
                )
              : Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  height: 35,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                    ),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          nameCheck = nameList
                              .where((element) => element
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                              .toList();
                        });
                      },
                      controller: _textEditingController,
                      decoration: const InputDecoration(
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: 'Enter Student name'),
                    ),
                  )),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    isSearching = !isSearching;
                  });
                  //showSearch(context: context, delegate: customSearchDelegate());
                },
                icon: const Icon(Icons.search))
          ]),
      drawer: Drawer(
          backgroundColor: Colors.white,
          child: ListView(padding: EdgeInsets.zero, children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.black),
              accountName: Text(
                name.toUpperCase(),
                style:
                    const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              ),
              accountEmail: Text(email),
              currentAccountPicture: Row(
                children: [
                  const SizedBox(
                    width: 0,
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(image), radius: 36,

                    // child: Text(
                    //   'MP',
                    //   style: TextStyle(
                    //     fontSize: 40.0,
                    //     color: Colors.black,
                    //   ),
                    // ),
                  ),
                ],
              ),
            ),
            // ListTile(
            //   leading: const Icon(Icons.home),
            //   title: const Text('Home'),
            //   onTap: () {
            //     // TODO: NavigNavigator.pop(context); // close the drawer
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => const SearchScreen()),
            //     );
            //   },
            // ),
            ListTile(
                leading: const Icon(Icons.home),
                title: const Text('HOME'),
                onTap: () {
                  Navigator.push;
                  {
                    // TODO: Logout tNavigator.pop(context); // close the drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchScreen()),
                    );
                  }
                }),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('EDIT PROFILE'),
              onTap: () {
                // TODO: Logout tNavigator.pop(context); // close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileUser()),
                );
              },
            ),
            const Divider(),
            ListTile(
                leading: const Icon(Icons.group),
                title: const Text('ABOUT US'),
                onTap: () {
                  Navigator.push;
                  {
                    // TODO: Logout tNavigator.pop(context); // close the drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutUs()),
                    );
                  }
                }),
            const Divider(),
            ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('LOGOUT'),
                onTap: () async {
                  final res = await AuthServices.signout();
                  if (res == null) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: res));
                  }
                }),
          ])),
      body: _searchResult.isNotEmpty || _searchController.text.isNotEmpty
          ? ListView.builder(
              itemCount: _searchResult.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_searchResult[index]),
                );
              },
            )
          : ListView.builder(
              itemCount: _dataList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_dataList[index]),
                );
              },
            ),
    );
  }

  void onSearchTextChanged(String text) {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    for (var item in _dataList) {
      if (item.toLowerCase().contains(text.toLowerCase())) {
        _searchResult.add(item);
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }
}

class UserBox extends StatelessWidget {
  final String name;
  final String email;
  final String phone;

  const UserBox(
      {super.key,
      required this.name,
      required this.email,
      required this.phone});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            email,
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            phone,
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
