import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'gif_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;
  int _offset = 0;

  TextEditingController searchControler;

  Future<Map> _getGifs() async {
    try {
      http.Response response;
      if (_search == null) {
        response = await http.get(
            "https://api.giphy.com/v1/gifs/trending?api_key=eMZXqvULTV8JhSDVmuZYq8iUBY9joPly&limit=20&rating=G");
      } else {
        response = await http.get(
            "https://api.giphy.com/v1/gifs/search?api_key=eMZXqvULTV8JhSDVmuZYq8iUBY9joPly&q=$_search&limit=20&offset=$_offset&rating=G&lang=en");
      }
      return json.decode(response.body);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _getGifs().then((map) {
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Image.network(
            "https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif",
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Pesquise aqui!",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5,
                      ),
                    );

                    break;
                  default:
                    if (snapshot.hasError) {
                      return Container();
                    } else {
                      return _createGitTable(context, snapshot);
                    }
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

Widget _createGitTable(BuildContext context, AsyncSnapshot snapshot) {
  return GridView.builder(
    padding: EdgeInsets.all(16),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 8,
    ),
    itemCount: snapshot.data['data'].length,
    itemBuilder: (context, index) {
      return GestureDetector(
        child: Image.network(
          snapshot.data['data'][index]['images']['fixed_height']['url'],
          height: 300.0,
          fit: BoxFit.cover,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GifPage(
                snapshot.data['data'][index],
              ),
            ),
          );
        },
      );
    },
  );
}
