import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'data.dart';

class Audio extends StatefulWidget {
  Gospel gospel;

  Audio(this.gospel);

  @override
  _Audio createState() => _Audio(this.gospel);
}

class _Audio extends State<Audio> {
  Gospel gospel;
  final audioPlayer = AudioPlayer();
  bool playing = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  _Audio(this.gospel);

  @override
  void initState()  {
    super.initState();
    setAudio(this.gospel);
  }

  @override
  void dispose()  {
    audioPlayer.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) => Flexible(
      fit: FlexFit.tight,
      //padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                fit: FlexFit.tight,
                child:CupertinoSlider(
                  min: 0,
                  max: 1,
                  value: _currentValue(),
                  onChanged: (value) async{
                    final position = Duration(seconds: (value * duration.inSeconds.toDouble()).toInt());
                    await audioPlayer.seek(position);

                    await audioPlayer.resume();
                    setState((){
                      playing = true;
                    });
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formatTime(position)),
                Text(formatTime(duration)),
              ],
            ),
          ),
          CircleAvatar(
            radius: 45,
            child: IconButton(
              icon: Icon(
                playing ? Icons.pause : Icons.play_arrow,
              ),
              iconSize: 70,
              onPressed: () async {
                if(playing) {
                  await audioPlayer.pause();
                } else {
                  await audioPlayer.resume();
                }
                setState((){
                  playing = !playing;
                });
              },
            ),
          ),
        ],
      )
    );
  String formatTime(Duration duration)  {
    String twoDigits(int n) => n.toString().padLeft(2,'0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [if (duration.inHours>0) hours, minutes, seconds,].join(':');
  }

  Future setAudio(Gospel gospel) async {
    String url = 'https://${dotenv.env['BASEPATH'] ?? ''}/assets/${gospel.audio}';
    audioPlayer.setSourceUrl(url);
    Duration songDuration = await audioPlayer.getDuration() ?? Duration.zero;
    duration = songDuration;

    this.audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
        audioPlayer.pause();
      });
    });
    this.audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }
  double _currentValue() {
    if(duration.inSeconds.toDouble()==0) return 0;

    return position.inSeconds.toDouble()/duration.inSeconds.toDouble();
  }
}