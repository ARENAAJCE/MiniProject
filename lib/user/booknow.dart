import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchResultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'OWNER') // Filter by role
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final stadiums = snapshot.data!.docs;
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: stadiums.length,
              itemBuilder: (context, index) {
                final stadium = stadiums[index].data();
                final name = stadium['Stadium Name'] ?? 'Unknown Stadium';
                final details = stadium['Address'] ?? 'Unknown Address';
                final image = stadium['imageLink'] ?? '';

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookNowPage(
                          name: name,
                          image: image,
                        ),
                      ),
                    );
                  },
                  child: StadiumCard(
                    name: name,
                    details: details,
                    image: image,
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class StadiumCard extends StatelessWidget {
  final String name;
  final String details;
  final String image;

  const StadiumCard({
    required this.name,
    required this.details,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 2),
            blurRadius: 4.0,
          ),
        ],
      ),
      child: Card(
        elevation: 0.0, // Set elevation to 0 to prevent double shadows
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8.0)),
              child: Image.network(
                image,
                fit: BoxFit.cover,
                height: 200.0,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${name}:',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    details,
                    style: const TextStyle(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookNowPage extends StatelessWidget {
  final String name;
  final String image;

  const BookNowPage({
    required this.name,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name), // Show the stadium name in the app bar
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance
            .collection('users')
            .where('Stadium Name', isEqualTo: name)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
            return Center(
              child: Text('No data found'),
            );
          } else {
            final stadiumData = snapshot.data!.docs[0].data();
            final owner = stadiumData['username'] ?? 'Unknown Owner';
            final address = stadiumData['Address'] ?? 'Unknown Address';
            final facilities = stadiumData['Facilities'] ?? 'Unknown Facilities';
            final rentalCharges = stadiumData['Rental Charges'] ?? 'Unknown Rental Charges';
            final capacity = stadiumData['Capacity'] ?? 'Unknown Capacity';
            final phone = stadiumData['phone'] ?? 'Unknown Phone';
            final email = stadiumData['email'] ?? 'Unknown Email';

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: Offset(0, 2),
                          blurRadius: 4.0,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
                      child: Image.network(
                        image,
                        fit: BoxFit.cover,
                        height: 200.0,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  buildInfoBox('Owner', owner),
                  SizedBox(height: 16.0),
                  buildInfoBox('Address', address),
                  SizedBox(height: 16.0),
                  buildInfoBox('Facilities', facilities),
                  SizedBox(height: 16.0),
                  buildInfoBox('Rental Charges', rentalCharges),
                  SizedBox(height: 16.0),
                  buildInfoBox('Capacity', capacity),
                  SizedBox(height: 16.0),
                  buildInfoBox('Phone', phone),
                  SizedBox(height: 16.0),
                  buildInfoBox('Email', email),
                  SizedBox(height: 16.0),
                  Center( // Center the button
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => BookingsPage(name: name)),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black, // Set button color to black
                        ),
                        child: Text('Book Now'),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildInfoBox(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 4.0),
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BookingsPage extends StatelessWidget {
  final String name;

  const BookingsPage({
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookings for $name'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Text('Bookings page for $name'),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stadium App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SearchResultPage(),
    );
  }
}
