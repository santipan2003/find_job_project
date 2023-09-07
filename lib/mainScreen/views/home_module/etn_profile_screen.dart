import 'package:flutter/material.dart';

class EtnScreen extends StatelessWidget {
  final String name;
  final String assetPath;
  final String age;
  final String title;
  final String location;

  EtnScreen({
    required this.name,
    required this.assetPath,
    required this.age,
    required this.title,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          name,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,  // Remove shadow
      ),
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: NetworkImage(assetPath),
                    ),
                    SizedBox(height: 20),
                    Row(  // Row for name
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // company icon
                        SizedBox(width: 8),
                        Text(
                          '$name',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(  // Row for title
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search, color: Colors.black54,),  // work icon
                        SizedBox(width: 8),
                        Text(
                          ': $title',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(  // Row for location
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_on, color: Colors.black54,),  // location icon
                        SizedBox(width: 8),
                        Text(
                          ': $location',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
