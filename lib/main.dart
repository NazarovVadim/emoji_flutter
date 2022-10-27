import 'package:emoji_game/screens/homePage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(currPoints: 0, questionIndex: 0,),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(scaffoldBackgroundColor: Color.fromARGB(255, 66, 66, 66)),
  ));
}


