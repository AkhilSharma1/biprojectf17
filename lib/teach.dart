import 'package:flutter/material.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Teach',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(algoType: 'Global', matrixSize: 5), //TODO get data from home screen
    );
  }
}


/*class TeachPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
  }
}*/

class ScoreSection extends StatelessWidget{

  final int leftScore, upScore, rightScore, upAdd, leftAdd, diagAdd;
  final bool isAMatch;

  ScoreSection(this.leftScore, this.upScore, this.rightScore, this.upAdd,
      this.leftAdd, this.diagAdd, this.isAMatch);

  //TODO : add formatting
  Text buildScoreText(BuildContext context, String loc,int prevScore, int delta) {
    return new Text(
      '$loc : $prevScore + ($delta) = ${prevScore+delta}',
//      style: Theme.of(context).textTheme.display1,


    );
  }

  Text buildMatchText() {
    Color textColor = isAMatch?Colors.green:Colors.red;
    String text  = isAMatch?'MATCH':'MISMATCH';

    return new Text(
      text,
      style: new TextStyle(
          color: textColor
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return new Container(
        padding: const EdgeInsets.all(32.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildScoreText(context, 'UP SCORE',0,0),
                buildScoreText(context, 'LEFT SCORE',0,0),
                buildScoreText(context, 'DIAG SCORE',0,0),
              ],
            ),
            buildMatchText()
          ],
        )
    );
  }

}

class MatrixSection extends
StatelessWidget {
//StatefulWidget{

  /* @override
  State<StatefulWidget> createState() {
    return null;
  }*/
  @override
  Widget build(BuildContext context) {
    return new Text('Matrix');
  }
}



class MyHomePage extends
StatelessWidget {
//StatefulWidget {
  MyHomePage({Key key, this.algoType, this.matrixSize}) : super(key: key);

  final String algoType;
  final int matrixSize ;

//for scoring section
  int leftScore, upScore, rightScore, upAdd, leftAdd, diagAdd;
  bool isAMatch;


  @override
  Widget build(BuildContext context) {


    return new Scaffold(
      appBar: new AppBar(
        title: new Text(algoType),
      ),
      body:  new Column(

        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new ScoreSection(leftScore, upScore, rightScore, upAdd, leftAdd, diagAdd, false),
          new MatrixSection(),
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: null, //TODO
        tooltip: 'Next',
        child: new Icon(Icons.navigate_next),
      ),
    );
  }

/*  @override
  State<StatefulWidget> createState() {
    return null;
  }*/
}



/*


new Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),


*/