import 'package:flutter/material.dart';
import 'audio.dart';
import 'connection.dart';

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
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Color.fromARGB(216, 215, 249, 255),
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
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Text('Evangelio y Familia',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 26,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text('Aquí debe incluír una descripción del evangelio del día, esto es una sobre extensión del texto para asegurarme de cómo está, y cómo se comporta el widget al momento de agregar una gran cantidad de caracteres',
              style: TextStyle(
                  fontStyle: FontStyle.italic
              ),
            ),
            SizedBox(
              height: 30,
            ),
            _image(),
            audio(),
          ],
        ),
      ),
    );
  }
  _image() async {
    Data url = new Data('', '', '', '', '', '', '', '', '', '', '');
    String link = await url.imageLink();
    print(link);
    return Expanded(
      //padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 350,
        margin: EdgeInsets.fromLTRB(25.0, 0, 25.0, 0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          image: const DecorationImage(
            //image: NetworkImage('https://i.pinimg.com/originals/dc/53/92/dc539209734c3ec8ed8e7eb758220adf.jpg'),
            image: NetworkImage('https://e9pgx4s3.directus.app/assets/03687d42-9e25-4669-b501-39c9fd4f3fb0'),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
            color: Colors.black54,
            offset: Offset(4.0, 7.0),
            blurRadius: 3.0,
            )
          ],
        ),
      ),
    );
  }
}