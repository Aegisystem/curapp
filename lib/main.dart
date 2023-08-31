import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'audio.dart';
import 'data.dart';

const String LOCALE_ES = 'es';

Future main() async {
  await dotenv.load(fileName: '.env');

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]
  );
  
  if(Platform.isIOS) {
    AudioPlayer.global.setGlobalAudioContext(audioContext);
  }

  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Evangelio y Familia',
      theme: ThemeData(),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    initializeDateFormatting(LOCALE_ES);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(250, 250, 250, 250),
      body: buildTodayGospelWidget(),
    );
  }

  buildTodayGospelWidget() {
    return FutureBuilder<GetGospelsResponse>(
        future: getGospel(),
        builder: (BuildContext context, AsyncSnapshot<GetGospelsResponse> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: const CircularProgressIndicator()
            );
          } else {
            final Gospel todayGospel = snapshot.data!.items[0];
            return Column(
              mainAxisAlignment:MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(
                  height: 45,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Image(
                      image: AssetImage('assets/images/icon.png'),
                      alignment: Alignment.topLeft,
                      height: 50,
                    ),
                    Text('Evangelio y Familia',
                    style: GoogleFonts.greatVibes(
                      fontSize: 38,
                      color: const Color.fromARGB(255, 45, 108, 163),
                      )
                    ),
                  ]
                ),
                _getFormattedDateWidget(todayGospel),
                Container(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                    child: Text(
                      todayGospel.headline,
                      style: GoogleFonts.merriweather(fontSize: 18),
                      textAlign: TextAlign.center,
                    )
                ),
                const SizedBox(
                  height: 30,
                ),
                  _image(todayGospel),
                  Audio(todayGospel)
              ]
            );
          }
        },
    );
  }
}
  _image(Gospel gospel)  {
    String url = 'https:${gospel.image}';

    return Flexible(
      fit: FlexFit.tight,
      child: Container(
        height: 50,
        margin: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          image: DecorationImage(
            image: CachedNetworkImageProvider(url),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  _getFormattedDateWidget (Gospel gospel)  {
    final DateTime date = gospel.date;
    final String formattedDate = toBeginningOfSentenceCase('${DateFormat.EEEE(LOCALE_ES).format(date)}, '
        '${DateFormat.d(LOCALE_ES).format(date)} de ${DateFormat.MMMM(LOCALE_ES).format(date)}'
        ' de ${DateFormat.y(LOCALE_ES).format(date)}') ?? '';
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(formattedDate,
        style: GoogleFonts.merriweather(
          fontSize: 18
        ),
      )
    );
  }

  final AudioContext audioContext = AudioContext(
    iOS: AudioContextIOS(
      defaultToSpeaker: true,
      category: AVAudioSessionCategory.ambient,
      options: [
        AVAudioSessionOptions.defaultToSpeaker,
        AVAudioSessionOptions.mixWithOthers,
      ],
    ),
    android: AudioContextAndroid(
      isSpeakerphoneOn: true,
      stayAwake: true,
      contentType: AndroidContentType.sonification,
      usageType: AndroidUsageType.assistanceSonification,
      audioFocus: AndroidAudioFocus.none,
    ),
  );