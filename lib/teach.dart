import 'dart:collection';

import 'package:biproject/algorithms/global_alignment.dart';
import 'package:biproject/algorithms/matrix.dart';
import 'package:biproject/algorithms/models/cell.dart';
import 'package:biproject/algorithms/seq_alignment.dart';
import 'package:biproject/algorithms/similarity_matrix.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(new MyApp());
}

class ScoreSection extends StatelessWidget {
  final int leftScore, upScore, diagScore, gapPenalty, diagAdd;
  final bool isAMatch;
  String dbChar, queryChar;

  ScoreSection(this.dbChar, this.queryChar, this.leftScore, this.upScore,
      this.diagScore, this.gapPenalty, this.diagAdd, this.isAMatch);

  //TODO : add formatting
  Text buildScoreText(
       String loc, int prevScore, int delta,{bool bold:false}) {
    return new Text(
      '$loc : $prevScore + ($delta) = ${prevScore+delta}',
      style: new TextStyle(
        fontWeight: bold?FontWeight.bold:FontWeight.normal,
        fontSize: 20.0
      )
    );
  }

  Widget buildMatchText() {
    Color textColor = isAMatch ? Colors.green : Colors.red;
    String text = isAMatch ? 'MATCH' : 'MISMATCH';

    return new Container(
      margin: new EdgeInsets.only(bottom: 25.0),
        child: new Text(
          text,
          style: new TextStyle(color: textColor),
        )
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
              children:buildScoreTexts()
            ),
            buildMatchText()
          ],
        ));
  }

  List<Widget> buildScoreTexts(){
    int scoreFromLeft = leftScore + gapPenalty;
    int scoreFromUp = upScore + gapPenalty;
    int scoreFromDiag  = diagScore + diagAdd;
    List<Widget> texts = new List<Widget>();

    if(scoreFromLeft >=scoreFromUp && scoreFromLeft>=scoreFromDiag){
      texts.add(buildScoreText( 'LEFT SCORE', leftScore, gapPenalty, bold: true));
      texts.add(buildScoreText( 'UP SCORE', upScore, gapPenalty));
      texts.add(buildScoreText( 'DIAG SCORE', diagScore, diagAdd));

    }else if(scoreFromUp >=scoreFromLeft && scoreFromUp>=scoreFromDiag){
    texts.add(buildScoreText( 'LEFT SCORE', leftScore, gapPenalty));
    texts.add(buildScoreText( 'UP SCORE', upScore, gapPenalty,bold: true));
    texts.add(buildScoreText( 'DIAG SCORE', diagScore, diagAdd));
    }else{
    texts.add(buildScoreText( 'LEFT SCORE', leftScore, gapPenalty));
    texts.add(buildScoreText( 'UP SCORE', upScore, gapPenalty));
    texts.add(buildScoreText( 'DIAG SCORE', diagScore, diagAdd,bold: true));
  }

  return texts;
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
  String dbSeq, querySeq, dbChar, queryChar;
  List<List<bool>> traceBackMatrix;

  //for scoring section
  int leftScore, upScore, diagScore, gapPenalty, diagAdd;
  bool isAMatch, highlightTBCells;


  _MatrixState(this.querySeq, this.dbSeq, SeqAlignment seqAlignmentAlgorithm) {
    numRows = querySeq.length + 2;
    numCols = dbSeq.length + 2;

    seqAlignmentAlgorithm.solve();
    solutionMatrix = seqAlignmentAlgorithm.matrix;
    initializeMatrixValues();
    intializeTraceBackMatrix(seqAlignmentAlgorithm.tracebackStack);
    calculateScoreSectionVals();
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
  Widget buildTracebackText(String matrixValue) {
    return buildText(matrixValue, bgColor: Colors.red);
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
        textScaleFactor: 2.0,
        textAlign: TextAlign.center,
        style: new TextStyle(color: textColor),
      ),
    );
  }

  Widget getTextView(String matrixValue, int row, int col) {

    if(highlightTBCells==true) {
      if (traceBackMatrix[row][col] == true)
        return buildTracebackText(matrixValue);
      else
        return buildDisabledText(matrixValue);
    }

    if(row == cRow && col == cCol)
      return buildHighlightedText(matrixValue);
    if((row == cRow-1 && col == cCol-1) || (row == cRow && col == cCol-1) || (row == cRow-1 && col == cCol))
      return buildNeighborText(matrixValue);

    return buildDisabledText(matrixValue);
  }


  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        new ScoreSection(dbChar, queryChar, leftScore, upScore, diagScore,
            gapPenalty, diagAdd, isAMatch),
        new Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
          new Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: buildRows(),
          ),
//          new Expanded(child:
          new Center(
            child: new FloatingActionButton(
              onPressed: () {
                updateMatrix();
              },
              tooltip: 'Next',
              child: new Icon(Icons.navigate_next),
            ),
          ),
//          )

        ]),
      ],
    );
  }

  void calculateScoreSectionVals() {
    print('$cRow:$cCol');
    leftScore = solutionMatrix.getScore(cRow - 1, cCol - 2);
    diagScore = solutionMatrix.getScore(cRow - 2, cCol - 2);
    upScore = solutionMatrix.getScore(cRow - 2, cCol - 1);

    print('$cRow:$cCol -> $leftScore, $diagScore, $upScore');

    gapPenalty = -1;
    diagAdd = querySeq[cRow - 2] == dbSeq[cCol - 2] ? 1 : -1;
    isAMatch = querySeq[cRow - 2] == dbSeq[cCol - 2] ? true : false;
    dbChar = dbSeq[cCol - 2];
    queryChar = querySeq[cRow - 2];
  }

  updateMatrix() {
    if (cRow >= numRows) return;
    setState(() {
      matrixValues[cRow][cCol] =
          solutionMatrix.getScore(cRow - 1, cCol - 1).toString();

      cCol++;
      if (cCol == numCols) {
        cCol = 2;
        cRow++;
      }
      if (cRow >= numRows) {
        highlightTBCells = true;
        return;
      }

      calculateScoreSectionVals();
    });
  }

  List<Widget> buildRows() {
    List<Row> mRows = new List();

    for (int row = 0; row < numRows; row++) {
      mRows.add(buildRow(row));
    }

    return mRows;
  }

  void initializeMatrixValues() {
    matrixValues = new List<List<String>>(numRows);
    for (int row = 0; row < numRows; row++) {
      matrixValues[row] = new List<String>(numCols);
    }


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
      texts.add(getTextView( matrixValues[row][col], row, col,));
    }
    return new Row(children: texts);
  }

  String getDisplayScore(int row, int col) {
    if (row <= cRow && col < cCol) {
      String val = solutionMatrix.getScore(row - 1, col - 1).toString();
      return val; //solution matrix has 1 less row and column
    }

    return '-';
  }

  void intializeTraceBackMatrix(ListQueue<Cell> tracebackStack) {
    traceBackMatrix = new List<List<bool>>(numRows);
    for (int row = 0; row < numRows; row++) {
      traceBackMatrix[row] = new List<bool>(numCols);
    }


    while(tracebackStack.isNotEmpty){
      Cell cell = tracebackStack.removeFirst();
      traceBackMatrix[cell.row+1][cell.col+1] = true;
    }

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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(seqAlgorithm),
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new MatrixSection(
              new GlobalAlignment(-1, new SimilarityMatrix(), "AB", "CB"),
              "AB",
              "CB"),
        ],
      ),
    );
  }
}
