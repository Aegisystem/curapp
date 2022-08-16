import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'audio.dart';
import 'data.dart';

const String LOCALE_ES = 'es';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Evangelio y Familia',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
      ),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: const Color.fromARGB(250, 250, 250, 250),
      /*appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),*/
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: buildTodayGospelWidget(),
        ),
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
            final Gospel todayGospel = snapshot.data!.data[0];
            return Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image(
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

                Text(todayGospel.headline,
                  style: GoogleFonts.merriweather(
                      fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                _image(todayGospel),
                Audio(todayGospel)
              ],
            );
          }
        },
    );
  }
}
  _image(Gospel gospel)  {
    //String link = await url.imageLink();
    //print(link);
    String url = 'https://e9pgx4s3.directus.app/assets/${gospel.image}';
    print(url + '? Hello World');

    return Expanded(
      //padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 50,
        margin: const EdgeInsets.fromLTRB(35.0, 0, 35.0, 0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          image: DecorationImage(
          //image: NetworkImage('https://i.pinimg.com/originals/dc/53/92/dc539209734c3ec8ed8e7eb758220adf.jpg'),
            image: CachedNetworkImageProvider(url),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  _getFormattedDateWidget (Gospel gospel)  {
    final DateTime date = gospel.date;
    final String formattedDate = toBeginningOfSentenceCase('${DateFormat.EEEE(LOCALE_ES).format(date)} '
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