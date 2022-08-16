import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
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

  void initState()  {
    super.initState();
    setAudio(this.gospel);
  }

  @override
  void dispose()  {
    audioPlayer.dispose();
  }

  Widget build(BuildContext context) => Container(
    height: 200,
    child: Expanded(
      //padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Slider.adaptive(
            min: 0,
            max: duration.inSeconds.toDouble(),
            value: position.inSeconds.toDouble(),
            onChanged: (value) async{
              final position = Duration(seconds: value.toInt());
              await audioPlayer.seek(position);

              audioPlayer.resume();
              setState((){
                playing = true;
              });
            },
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
    ),
  );
  String formatTime(Duration duration)  {
    String twoDigits(int n) => n.toString().padLeft(2,'0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [if(duration.inHours>0) hours, minutes, seconds,].join(':');
  }

  Future setAudio(Gospel gospel) async {
    String url = 'https://e9pgx4s3.directus.app/assets/${gospel.audio}';
    audioPlayer.setSourceUrl(url);
    Duration songDuration = await audioPlayer.getDuration() ?? Duration.zero;

    this.audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });
    this.audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }
}