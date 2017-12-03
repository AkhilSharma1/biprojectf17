import 'package:biproject/algorithms/global_alignment.dart';
import 'package:biproject/algorithms/matrix.dart';
import 'package:biproject/algorithms/seq_alignment.dart';
import 'package:biproject/algorithms/similarity_matrix.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(new MyApp());
}

class ScoreSection extends StatelessWidget {
  final int leftScore, upScore, rightScore, upAdd, leftAdd, diagAdd;
  final bool isAMatch;

  ScoreSection(this.leftScore, this.upScore, this.rightScore, this.upAdd,
      this.leftAdd, this.diagAdd, this.isAMatch);

  //TODO : add formatting
  Text buildScoreText(
      BuildContext context, String loc, int prevScore, int delta) {
    return new Text(
      '$loc : $prevScore + ($delta) = ${prevScore+delta}',
//      style: Theme.of(context).textTheme.display1,
    );
  }

  Text buildMatchText() {
    Color textColor = isAMatch ? Colors.green : Colors.red;
    String text = isAMatch ? 'MATCH' : 'MISMATCH';

    return new Text(
      text,
      style: new TextStyle(color: textColor),
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
                buildScoreText(context, 'UP SCORE', 0, 0),
                buildScoreText(context, 'LEFT SCORE', 0, 0),
                buildScoreText(context, 'DIAG SCORE', 0, 0),
              ],
            ),
            buildMatchText()
          ],
        ));
  }
}

class MatrixSection extends StatefulWidget {
//  final Matrix solvedMatrix; //provided by algo
//  final ListQueue traceBackStack;
  final String dbSeq, querySeq;

  SeqAlignment seqAlignmentAlgorithm;

  MatrixSection(this.seqAlignmentAlgorithm, this.querySeq, this.dbSeq);

  @override
  _MatrixState createState() =>
      new _MatrixState(querySeq, dbSeq, seqAlignmentAlgorithm);
}

class _MatrixState extends State<MatrixSection> {
  int numRows, numCols, cRow = 2, cCol = 2;
  List<List<String>> matrixValues;
  Matrix solutionMatrix;
  String dbSeq, querySeq;

  _MatrixState(this.querySeq, this.dbSeq, SeqAlignment seqAlignmentAlgorithm) {
    numRows = querySeq.length + 2;
    numCols = dbSeq.length + 2;
    matrixValues = new List<List<String>>(numRows);
    for (int row = 0; row < numRows; row++) {
      matrixValues[row] = new List<String>(numCols);
    }

    seqAlignmentAlgorithm.solve();
    solutionMatrix = seqAlignmentAlgorithm.matrix;
    initializeMatrixValues();
  }

  Widget buildDisabledText([String text = '-']) {
    return buildText(text);
  }

  Widget buildNeighborText(String text) {
    return buildText(text, bgColor: Colors.blue);
  }

  Widget buildHighlightedText(String text) {
    return buildText(text, bgColor: Colors.green);
  }

  Widget buildText(String text,
      {Color bgColor: Colors.grey, Color textColor: Colors.black}) {
    return new Container(
      margin: new EdgeInsets.all(5.0), //TODO formatting
      color: bgColor,
      width: 48.0,
      height: 48.0,
      child: new Text(
        text,
        style: new TextStyle(color: textColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //create alphabet row
    return new Expanded(
        child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: buildMatrixSectionViews()));
  }

  List<Widget> buildRows() {
    List<Row> mRows = new List();

    for (int row = 0; row < numRows; row++) {
      mRows.add(buildRow(row));
    }

    return mRows;
  }

  void initializeMatrixValues() {
    //first row (db letters)
    matrixValues[0][0] = '-';
    matrixValues[0][1] = '-';
    for (int col = 2; col < numCols; col++) {
      matrixValues[0][col] = dbSeq[col - 2];
    }

    //first column(query letters)
    matrixValues[1][0] = '-';
    for (int row = 2; row < numRows; row++) {
      matrixValues[row][0] = querySeq[row - 2];
    }
    //gap penalty row (2nd row)
    for (int col = 1; col < numCols; col++) {
      matrixValues[1][col] = solutionMatrix.getScore(0, col - 1).toString();
    }

    //gap penalty column(2nd column)
    for (int row = 1; row < numRows; row++) {
      matrixValues[row][1] = solutionMatrix.getScore(row - 1, 0).toString();
    }

    for (int row = 2; row < numRows; row++) {
      for (int col = 2; col < numCols; col++) {
        matrixValues[row][col] = getDisplayScore(row, col);
      }
    }
  }

  Row buildRow(int row) {
    List<Text> texts = new List();
    for (int col = 0; col < numCols; col++) {
      texts.add(buildDisabledText(matrixValues[row][col]));
    }
    return new Row(children: texts);
  }

  List<Widget> buildMatrixSectionViews() {
    List<Widget> views = new List<Widget>();
    views.add(new FloatingActionButton(
      onPressed: () {
        updateMatrix();
      },
      tooltip: 'Next',
      child: new Icon(Icons.navigate_next),
    ));
    views.addAll(buildRows());

    return views;
  }

  updateMatrix() {
    if (cRow >= numRows) return;
    setState(() {
      cCol++;
      if (cCol > numCols) {
        cCol = 3;
        cRow++;
      }
      if (cRow >= numRows) return;

      matrixValues[cRow][cCol-1] = solutionMatrix.getScore(cRow-1, cCol - 2).toString();
    });
  }

  String getDisplayScore(int row, int col) {
    if (row <= cRow && col < cCol) {
      String val = solutionMatrix.getScore(row - 1, col - 1).toString();
      return val; //solution matrix has 1 less row and column
    }

    return '-';
  }
}

//matrix section end

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Teach',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(
          seqAlgorithm: 'Global',
          matrixSize: 5), //TODO get data from home screen
    );
  }
}

class MyHomePage extends StatelessWidget {
//StatefulWidget {
  MyHomePage({Key key, this.seqAlgorithm, this.matrixSize}) : super(key: key);

  final String seqAlgorithm;
  final int matrixSize;

//for scoring section
  int leftScore, upScore, rightScore, upAdd, leftAdd, diagAdd;
  bool isAMatch;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(seqAlgorithm),
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new ScoreSection(
              leftScore, upScore, rightScore, upAdd, leftAdd, diagAdd, false),
          new MatrixSection(
              new GlobalAlignment(-1, new SimilarityMatrix(), "AB", "CB"),
              "AB",
              "CB"),
        ],
      ),
    );
  }
}
