import 'dart:async';
import 'dart:convert';

import 'package:api/delete.dart';
import 'package:api/photo.dart';
import 'package:api/post_or_send_data.dart';
import 'package:api/send_data_to_server.dart';
import 'package:api/update.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Album> fetchAlbum() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/100'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  const Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}

void main() => runApp(MaterialApp(
      home: const MyApp(),
      routes: {
        '/delete': (context) => const DeleteData(),
        '/photo': (context) => const FetchPhoto(),
        '/send_data': (context) => const SendData(),
        '/update_data': (context) => const UpdateData(),
        '/send_data_to_server': (context) => const SendDataToServer(),
      },
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    ));

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fetch Data Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<Album>(
              future: futureAlbum,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 5,
                    itemBuilder: (context, index) => ListTile(
                      title: Text('${snapshot.data!.title} = title'),
                      leading: Text('${snapshot.data!.id.toString()} = id'),
                      trailing:
                          Text('${snapshot.data!.userId.toString()} = User Id'),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/delete');
                },
                child: const Text('Delete Example')),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/photo');
                  },
                  child: const Text('Fetch Photo Example')),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/send_data');
                  },
                  child: const Text('Send Data to server')),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/update_data');
                  },
                  child: const Text('Update Data Example')),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/send_data_to_server');
                  },
                  child: const Text('Send Data To Server')),
            ),
          ],
        ),
      ),
    );
  }
}
