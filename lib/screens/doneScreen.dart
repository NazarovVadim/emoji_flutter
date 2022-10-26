import 'package:emoji_game/screens/homePage.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:flutter/services.dart';

class DoneScreen extends StatefulWidget {
  final String song;
  final int currPoints;
  final int rightSong;
  const DoneScreen({Key? key, required this.song, required this.currPoints, required this.rightSong}) : super(key: key);

  @override
  State<DoneScreen> createState() => _DoneScreenState();
}

// class YoutubeModel {
//   final int id;
//   final String youtubeId;
//
//   const YoutubeModel({required this.id, required this.youtubeId});
// }

class _DoneScreenState extends State<DoneScreen> {
  String songName = '';
  int points = 0;
  int right = 0;

  // YoutubePlayerController _ytbPlayerController = YoutubePlayerController(initialVideoId: 'F2AitTPI5U0');
  // List<YoutubeModel> videosList = [
  //   YoutubeModel(id: 1, youtubeId: 'F2AitTPI5U0'),
  // ];


  @override
  void initState() {

    songName = widget.song;
    points = widget.currPoints;
    right = widget.rightSong+1;

    // _setOrientation([
    //   DeviceOrientation.landscapeRight,
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);

    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    //   setState(() {
    //     _ytbPlayerController = YoutubePlayerController(
    //       initialVideoId: videosList[0].youtubeId,
    //       params: YoutubePlayerParams(
    //         showFullscreenButton: true,
    //       ),
    //     );
    //   });
    // });

    super.initState();
  }
  //
  // @override
  // void dispose() {
  //   super.dispose();
  //
  //   _setOrientation([
  //     DeviceOrientation.portraitUp,
  //     DeviceOrientation.portraitDown,
  //   ]);
  //
  //   _ytbPlayerController.close();
  // }
  //
  // _setOrientation(List<DeviceOrientation> orientations) {
  //   SystemChrome.setPreferredOrientations(orientations);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          //_buildYtbView(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Верно! Это $songName', style: TextStyle(fontSize: 40),)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage(currPoints: points,rightSong: right,),)
                );
              }, child: Text('Прордолжить', style: TextStyle(fontSize: 40),),)
            ],
          )

        ],
      ),
    );
  }

  // _buildYtbView() {
  //   return AspectRatio(
  //     aspectRatio: 16 / 9,
  //     child: _ytbPlayerController != null
  //         // ignore: deprecated_member_use
  //         ? YoutubePlayerIFrame(controller: _ytbPlayerController)
  //         : Center(child: CircularProgressIndicator()),
  //   );
  // }



}
