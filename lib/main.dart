import 'package:flutter/material.dart';
import 'package:biproject/teach.dart';
import 'package:biproject/solve.dart';

void main() {
  runApp(new MyApp());
}

final key = new GlobalKey<_MyHomePageState>();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
//      routes: <String, WidgetBuilder> {
//        '/solve': (BuildContext context) => new SolvePageDetails(),
//        '/learn' : (BuildContext context) => new LearnPage()
//      },
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ), key: key
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _value = 42;
  int get alignmentType => _value;

  @override
  Widget build(BuildContext context) {

    // Create button
    RaisedButton learnButton = new RaisedButton(
        color: Colors.blue.shade900,
        child: new Text("Learn",
          style: new TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        onPressed: () {
          print(key.currentState.alignmentType);
          Navigator.push(context, new MaterialPageRoute(
            builder: (BuildContext context) => new LearnPage(seqAlgorithm: '', matrixSize: 5)
          ));
        },
//        onPressed: () => Navigator.of(context).pushNamed('/learn')
    );

    RaisedButton solveButton = new RaisedButton(
        color: Colors.blue.shade900,
        child: new Text("Solve",
          style: new TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      onPressed: () {
        Navigator.push(context, new MaterialPageRoute(
            builder: (BuildContext context) => new SolvePageDetails(seqAlgorithm: 'Global', matrixSize: 5)
        ));
      },
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
              value: 42,
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
            onChanged: (newValue) =>
                setState(() => _value = newValue)),
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
                  margin: const EdgeInsets.only(top: 50.0),
                  child: alignmentType
              ),
              new Container(
                  margin: const EdgeInsets.only(top: 70.0),
                  child: new Row(
                    // <Widget> is the type of items in the list.
                    children: <Widget>[
                      new Column(
                          children: [learnButton,
                            new Container(
                              padding: const EdgeInsets.symmetric(horizontal: 105.0),
                            )
                          ]
                      ),
                      new Column(
                          children: [solveButton, new Container(
                            padding: const EdgeInsets.symmetric(horizontal: 60.0),
                          )]
                      )
                    ],
                  )
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