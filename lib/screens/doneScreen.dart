import 'package:emoji_game/screens/homePage.dart';
import 'package:flutter/material.dart';

class DoneScreen extends StatefulWidget {
  final int points;
  final int maxPoints;
  const DoneScreen({Key? key, required this.points, required this.maxPoints}) : super(key: key);

  @override
  State<DoneScreen> createState() => _DoneScreenState();
}

class _DoneScreenState extends State<DoneScreen> {
  int score = 0;
  int maxScore = 0;
  @override
  void initState() {
    score = widget.points;
    maxScore = widget.maxPoints;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Поздравляем!', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 30)),
            Text('Вы набрали $score баллов из ${maxScore*10} возможных!',style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 30)),
            const SizedBox(height: 50,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.cyan,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                textStyle: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 30,
                  fontWeight: FontWeight.w700
                )
              ),
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage(currPoints: 0, questionIndex: 0),)
                );
              },
              child: const Text('Начать заново')
            )
          ],
        ),
      )
    );
  }
}
