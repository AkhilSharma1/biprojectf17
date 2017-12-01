import 'package:flutter/material.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _value = 0;

  @override
  Widget build(BuildContext context) {

    // Create button
    RaisedButton submitButton = new RaisedButton(
        color: Colors.blue.shade900,
        child: new Text("Learn",
          style: new TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        onPressed: () {
          // More code goes here
        }
    );

    Theme alignmentType = new Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.grey.shade200,
        ),
        child: new DropdownButton(
          value: _value,
          items: <DropdownMenuItem<int>>[
            new DropdownMenuItem(
              child: new Text('Local Alignment',
                style: new TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.w400,
                color: Colors.blue,
                ),
              ),
              value: 0,
            ),
            new DropdownMenuItem(
              child: new Text('Global Alignment',
                style: new TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.blue,
                ),
              ),
              value: 1,
            ),
          ],
          onChanged: (int value) {
            setState(() {
              _value = value;
            });
          },
        )
    );

    Image image = new Image.asset(
          'images/dna-banner.jpg',
          height: 240.0,
          fit: BoxFit.cover,
        );

    Container container = new Container(
        padding: const EdgeInsets.all(16.0),
        child: new Column(
            children: [ image,
            new Container(
                margin: const EdgeInsets.only(top: 30.0),
                child: alignmentType
            ),
            new Container(
                margin: const EdgeInsets.only(top: 50.0),
                child: submitButton
            )
            ]
        )
    );

    AppBar appBar = new AppBar(title: new Text('Sequence Alignment Techniques'));

    Scaffold scaffold = new Scaffold(appBar: appBar,
        body: container);
    return scaffold;

  }
}

