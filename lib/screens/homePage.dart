import 'package:emoji_game/screens/doneScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import '../models/api.dart';

class HomePage extends StatefulWidget {
  final int currPoints;
  final int questionIndex;
  const HomePage({Key? key, required this.currPoints, required this.questionIndex}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var rng = Random();
  List<int> questionsOrder = [];
  int points =0;
  int record = 0;
  int right = 0;
  int currentIndex = 0;
  int indexSong = 0;
  late Future<List<Song>> futureSongs;


  void _getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('record') != null){
      setState((){
        record = prefs.getInt('record')!;
      });
    }
  }

  void _setPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('record', points);
  }

  List<int> generateSong() {
    var list = List.generate(11, (index) => index)..shuffle();
    return list;
  }

  bool checkAnswer(int idSong){
    return idSong == indexSong ? true : false;
  }


  @override
  void initState() {
    _getPrefs();
    points = widget.currPoints;
    currentIndex = widget.questionIndex;
    futureSongs = fetchSong();
    generateSong();
    questionsOrder = generateSong();
    print(questionsOrder);
    indexSong = questionsOrder[currentIndex];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: FutureBuilder<List<Song>>(
        future: futureSongs,
        builder: (context, snapshot){
          if(snapshot.hasData){
            // List<int> a = [
            //   questionsOrder[currentIndex+1],
            //   questionsOrder[currentIndex+2],
            //   questionsOrder[currentIndex+3]
            // ];
            return ListView.builder(
              itemCount: 1,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index){
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('$points Баллов', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 30),),
                          Text('${currentIndex+1}/11', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 30),),
                          Text('Рекорд:\n$record Баллов', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 30),),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //Text('Здесь будут эмодзи', style: TextStyle(fontSize: 40),)
                        Text(snapshot.data![indexSong].emoji, style: const TextStyle(fontSize: 80),)
                      ],
                    ),
                    const SizedBox(height: 60,),

                        GridView.builder(
                          shrinkWrap: true,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                          itemBuilder: (BuildContext context, int index){
                            return Card(
                              child: GridTile(
                                footer: Text(snapshot.data![indexSong].singer),
                                child: Text(snapshot.data![indexSong].name),
                              ),
                            );
                          }
                        )


                  ],
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator(),);
          }
        },
      ),
    );

  }
}
