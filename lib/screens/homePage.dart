import 'package:emoji_game/screens/doneScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SingingCharacter { first, second, third, fourth }

class HomePage extends StatefulWidget {
  final int currPoints;
  final int rightSong;
  const HomePage({Key? key, required this.currPoints, required this.rightSong}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SingingCharacter? _character = SingingCharacter.first;
  List<int> indexes = [1,2,3,4];
  int points =0;
  int record = 0;
  int right = 0;
  String nameSong = '';
  List<String> songs = [
    'Single Ladies - Beyonce',
    'Black Or White - Michael Jackson',
    'Dusk Till Dawn - ZAYN',
    'Black Space - Taylor Swift'
  ];
  List<SingingCharacter> characters = [
    SingingCharacter.first,
    SingingCharacter.second,
    SingingCharacter.third,
    SingingCharacter.fourth,
  ];

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

  @override
  void initState() {
    _getPrefs();
    points = widget.currPoints;
    right = widget.rightSong;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('$points Баллов', style: const TextStyle(color: Colors.black, fontSize: 30),),
                  Text('Рекорд: $record Баллов', style: const TextStyle(color: Colors.black, fontSize: 30),)
                ],
              ),
            ),
            const SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Text('Здесь будут эмодзи', style: TextStyle(fontSize: 40),)
                right==1 ? Image.asset('assets/blackorwhite.png', fit: BoxFit.fill,) : Image.asset('assets/dusktilldawn.png', fit: BoxFit.fill,)
              ],
            ),
            const SizedBox(height: 50,),


            ListView.builder(
              shrinkWrap: true,
              itemCount: 4,
              itemBuilder: (BuildContext context, int index){
                SingingCharacter? selected = SingingCharacter.first;

                selected = characters[index];
                nameSong = songs[index];
                return GestureDetector(
                  onTap: (){
                    setState((){
                      _character = characters[index];
                    });
                  },
                  child: Row(
                    children: [
                      const SizedBox(width: 200,),
                      Radio(
                          value: selected,
                          groupValue: _character,
                          onChanged: (SingingCharacter? value){
                            setState(() {
                              _character = value;
                            });
                          }
                      ),
                      Text(nameSong)
                    ],
                  ),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SizedBox(width: 1,),
                ElevatedButton(
                    onPressed: (){

                      if(_character == characters[right]){

                        setState((){
                          points+=10;
                          nameSong = songs[right];
                        });


                        if(points>record){
                          _setPrefs();
                        }

                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DoneScreen(song: nameSong, currPoints: points,rightSong: right,),)
                        );

                      } else{
                        setState((){
                          points=0;
                        });
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('Ок', style: TextStyle(fontSize: 30),),
                    )
                ),
              ],
            )
          ],
        ),
    );
  }
}
