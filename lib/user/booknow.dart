import 'package:flutter/material.dart';
import 'bookings.dart'; // Import the BookingsPage class

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
        title: Text(name),
        backgroundColor: Colors.black,
      ),
      body: Column(
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
          Text(
            'Owner: Rajesh PR',
            style: TextStyle(fontSize: 16.0),
          ),
          Text(
            'Address: GW64+X93, Shivaji Park, near Lulu Mall, Venpalavattom, Thiruvananthapuram, Kerala 695029',
            style: TextStyle(fontSize: 16.0),
          ),
          Text(
            'Facilities: Football Turf, Changing Room',
            style: TextStyle(fontSize: 16.0),
          ),
          Text(
            'Rental Charges: ₹50/hour',
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 16.0),
          Padding(
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
        ],
      ),
    );
  }
}