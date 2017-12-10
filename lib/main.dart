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
class Alignment {
  const Alignment(this.title,this.name);

  final String title;
  final String name;
}

class _MyHomePageState extends State<MyHomePage> {
  Alignment selectedType;
//  int get alignmentType => _value;
  List<Alignment> types = <Alignment>[const Alignment('Global Alignment', 'global'), const Alignment('Local Alignment', 'local')];

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
          print(selectedType.name);
          Navigator.push(context, new MaterialPageRoute(
            builder: (BuildContext context) => new LearnPage(seqAlgorithm: selectedType.name, matrixSize: 5)
          ));
        },
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
            builder: (BuildContext context) => new SolvePageDetails(seqAlgorithm: selectedType.name, matrixSize: 5)
        ));
      },
    );

    Theme alignmentType = new Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.grey.shade200,
        ),
        child: new DropdownButton<Alignment>(
          hint: new Text("Select an alignment type",
            style: new TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w400,
              color: Colors.blue,
            ),
          ),
          value: selectedType,
          onChanged: (Alignment newValue) {
            setState(() {
              selectedType = newValue;
            });
          },
          items: types.map((Alignment type) {
            return new DropdownMenuItem<Alignment>(
              value: type,
              child: new Text(
                type.title,
                style: new TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.blue,
                ),
              ),
            );
          }).toList(),
        ),
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