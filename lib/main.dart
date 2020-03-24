import 'package:flutter/material.dart';
import 'ui/home.dart';
import 'ui/gif_page.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData(
        hintColor: Colors.white,
      ),
    ),
  );
}
