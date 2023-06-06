import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devu/about.dart';
import 'package:devu/firebase/auth_services.dart';
import 'package:devu/loginandsignup/login.dart';
import 'package:devu/user/editprofileuser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:devu/user/searchresult.dart';

import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

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
  final TextEditingController _textEditingController =
      TextEditingController();

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
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
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
                      hintText: 'Enter Location',
                    ),
                  ),
                ),
              ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
              });
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.black),
              accountName: Text(
                name.toUpperCase(),
                style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              ),
              accountEmail: Text(email),
              currentAccountPicture: Row(
                children: [
                  const SizedBox(
                    width: 0,
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(image),
                    radius: 36,
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('HOME'),
              onTap: () {
                Navigator.pop(context); // close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('EDIT PROFILE'),
              onTap: () {
                Navigator.pop(context); // close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileUser()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('ABOUT US'),
              onTap: () {
                Navigator.pop(context); // close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutUs()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('LOGOUT'),
              onTap: () async {
                final res = await AuthServices.signout();
                if (res == null) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: res));
                }
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          _searchResult.isNotEmpty || _searchController.text.isNotEmpty
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
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchResultPage()),
                );
              },
              child: const Icon(Icons.search),
            ),
          ),
        ],
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

  const UserBox({
    Key? key,
    required this.name,
    required this.email,
    required this.phone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6.0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          const SizedBox(height: 8.0),
          Text('Email: $email'),
          Text('Phone: $phone'),
        ],
      ),
    );
  }
}

class SportsNewsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          SportsNewsItem(
            imageUrl: 'https://example.com/image1.jpg',
            title: 'Sports News 1',
          ),
          SportsNewsItem(
            imageUrl: 'https://example.com/image2.jpg',
            title: 'Sports News 2',
          ),
          SportsNewsItem(
            imageUrl: 'https://example.com/image3.jpg',
            title: 'Sports News 3',
          ),
          // Add more SportsNewsItem widgets here as needed
        ],
      ),
    );
  }
}

class SportsNewsItem extends StatelessWidget {
  final String imageUrl;
  final String title;

  const SportsNewsItem({
    Key? key,
    required this.imageUrl,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SearchScreen(),
  ));
}
