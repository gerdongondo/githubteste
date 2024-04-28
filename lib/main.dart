import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          title: Text(
            'Album List',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: AlbumWidgets(),
      ),
    );
  }
}

class AlbumWidgets extends StatefulWidget {
  const AlbumWidgets({super.key});

  @override
  State<AlbumWidgets> createState() => _AlbumWidgetsState();
}

class _AlbumWidgetsState extends State<AlbumWidgets> {
  Future<List<Map<String, dynamic>>> fetchAlbums() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/albums'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('failed to load albums');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchAlbums(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error :${snapshot.error}'),
            );
          } else {
            List<Map<String, dynamic>> albums = snapshot.data!;
            return ListView.builder(
                itemCount: albums.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Row(children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${albums[index]['id']}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                          child: Text(
                        albums[index]['title'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))
                    ]),
                  );
                });
          }
        });
  }
}
