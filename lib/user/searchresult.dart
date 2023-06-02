import 'package:flutter/material.dart';
import 'package:devu/user/booknow.dart';

class SearchResultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BookNowPage(
                    name: 'Hustle Football Turf',
                    image: 'https://img.redbull.com/images/q_auto,f_auto/redbullcom/2020/12/15/spsk7mqyvepduccdvy4p/sporthood-espirito-football-turf-ground-kochi-kerala',
                  ),
                ),
              );
            },
            child: const StadiumCard(
              name: 'Hustle Football Turf',
              details: 'Kochi, Kerala',
              image: 'https://img.redbull.com/images/q_auto,f_auto/redbullcom/2020/12/15/spsk7mqyvepduccdvy4p/sporthood-espirito-football-turf-ground-kochi-kerala',
            ),
          ),
          const SizedBox(height: 16.0),
          const StadiumCard(
            name: 'Sparta Arena',
            details: 'Thiruvananthapuram, Kerala',
            image: 'https://images.jdmagicbox.com/comp/thiruvananthapuram/y7/0471px471.x471.211001205709.g9y7/catalogue/club-de-by-kerala-house-nedumangadu-thiruvananthapuram-football-turf-grounds-46k0adu1vz.jpg',
          ),
          const SizedBox(height: 16.0),
          const StadiumCard(
            name: 'Raja Reddy Turf',
            details: 'Bengaluru, Karnataka',
            image: 'https://media.hudle.in/venues/8e66e6c5-4d94-48a6-81cb-39458d2c5ed7/photo/4d6d3209e7861f2fccd11fc56ef4b5aa2e683262',
          ),
        ],
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
                    name,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(details),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}