import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class Song{
  Song({
    required this.id,
    required this.name,
    required this.singer,
    required this.emoji
  });

  final String id;
  final String name;
  final String singer;
  final String emoji;

  factory Song.fromJson(Map<String, dynamic> data) {
    final id = data['id'] as String; // cast as non-nullable String
    final name = data['name'] as String; // cast as non-nullable String
    final singer = data['singer'] as String; //// cast as nullable int
    final emoji = data['emoji'];
    return Song(id: id, name: name, singer: singer, emoji: emoji);
  }
}

Future<List<Song>> fetchSong() async {
  //var result = await http.get(Uri.parse("https://forrus.ru/api/news/"));
  var result = await http.get(Uri.parse('https://my-json-server.typicode.com/NazarovVadim/emojiserver/songs'));
  var jsonData = jsonDecode(result.body);
  List<Song> songs = [];

  for(var jsonSongs in jsonData){

    Song article = Song(
      id: jsonSongs['id'],
      name: jsonSongs['name'],
      singer: jsonSongs['singer'],
      emoji: jsonSongs['emoji']
    );
    songs.add(article);
  }
  return songs;
}

