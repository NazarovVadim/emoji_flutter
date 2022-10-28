import 'dart:async';

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
  List<int> q = [];
  int points =0;
  int record = 0;
  int right = 0;
  int currentIndex = 0;
  int indexSong = 0;
  int isCorrectAnswer = 0; // -1 is wrong; 1 is right; 0 is clear
  int isSelectedAnswer = 0; //0 - nothing select
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

  List<int> generateAnswers(int id){
    Random rnd = new Random();
    int r = 0;
    List<int> vars = [];
    vars.add(id);
    for(int i=0; i<3; i++){
      r = rnd.nextInt(10);
      if(vars.contains(r)) i--;
      else vars.add(r);

    }
    vars = vars..shuffle();
    print(vars);
    return vars;

  }

 void nextQuestion (bool isCorrect){
   setState((){
     isCorrectAnswer = 0;
     isSelectedAnswer = 0;
     if(isCorrect){
       points+=10;
     }
     if(points>record) _setPrefs();
     currentIndex++;
     indexSong = questionsOrder[currentIndex];
     q = generateAnswers(indexSong);
   });
 }


  @override
  void initState() {
    _getPrefs();
    points = widget.currPoints;
    currentIndex = widget.questionIndex;
    futureSongs = fetchSong();
    generateSong();
    questionsOrder = generateSong();
    indexSong = questionsOrder[currentIndex];
    q = generateAnswers(indexSong);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: FutureBuilder<List<Song>>(
        future: futureSongs,
        builder: (context, snapshot){
          if(snapshot.hasData){
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

                    GridView.count(
                      crossAxisCount: 4,
                      shrinkWrap: true,
                      children: List.generate(4, (index){
                        return GestureDetector(
                          onTap: (){
                            if(q[index]==indexSong){
                              setState((){
                                isCorrectAnswer = 1;
                                isSelectedAnswer = index;
                                Timer(Duration(seconds: 1), () => nextQuestion(true));
                              });
                            } else {
                              setState((){
                                isSelectedAnswer = index;
                                isCorrectAnswer = - 1;
                                Timer(Duration(seconds: 1), () => nextQuestion(false));

                              });
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: isCorrectAnswer == 1 && isSelectedAnswer==index ? Colors.lightGreen : isCorrectAnswer == -1 && isSelectedAnswer==index ? Colors.redAccent : Colors.blueAccent,
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    snapshot.data![q[index]].name,
                                    style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    snapshot.data![q[index]].singer,
                                    style: TextStyle(fontSize: 18, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
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
