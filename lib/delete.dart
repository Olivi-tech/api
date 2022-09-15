import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Album> fetchData() async {
  final http.Response response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/50'));
  if (response.statusCode == 200) {
    return Album.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load Album');
  }
}

Future<Album> deleteData(String id) async {
  final http.Response response = await http.delete(
      Uri.parse('https://jsonplaceholder.typicode.com/albums/$id'),
      headers: {HttpHeaders.authorizationHeader: 'Basic api token here'});

  if (response.statusCode == 200) {
    return Album.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Exception: Failed to load');
  }
}

class Album {
  final int id;
  final int userId;
  final String title;

  Album({required this.id, required this.userId, required this.title});
  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(id: json['id'], userId: json['userId'], title: json['title']);
  }
}

class DeleteData extends StatefulWidget {
  const DeleteData({Key? key}) : super(key: key);
  final String _title = 'Delete data';

  @override
  State<DeleteData> createState() => _DeleteDataState();
}

class _DeleteDataState extends State<DeleteData> {
  late Future<Album> _future;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<Album>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        ListTile(
                          title: Text(
                              snapshot.data?.title.toString() ?? 'Deleted'),
                          leading: Text(
                              snapshot.data?.userId.toString() ?? 'Deleted'),
                          trailing:
                              Text(snapshot.data?.id.toString() ?? 'Deleted'),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _future =
                                    deleteData(snapshot.data!.id.toString());
                              });
                            },
                            child: Text(widget._title))
                      ],
                    );
                  }
                } else if (snapshot.hasError) {
                  return Text(snapshot.hasError.toString());
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                return const Text('No Data');
              },
            ),
          ],
        ),
      ),
    );
  }
}
