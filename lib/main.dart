import 'package:emoji_game/screens/homePage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: HomePage(currPoints: 0, rightSong: 1,),
    debugShowCheckedModeBanner: false,
  ));
}


