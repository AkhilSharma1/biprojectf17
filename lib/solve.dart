import 'package:biproject/algorithms/global_alignment.dart';
import 'package:biproject/algorithms/matrix.dart';
import 'package:biproject/algorithms/seq_alignment.dart';
import 'package:biproject/algorithms/similarity_matrix.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';


final key = new GlobalKey<_NumberPickerState>();

class NumberPickerSection extends StatefulWidget {

  NumberPickerSection({ Key key }) : super(key: key);
  @override
  _NumberPickerState createState() =>
      new _NumberPickerState();
}


class _NumberPickerState extends State<NumberPickerSection> {
  int _currentValue = 1;
  int get currentValue => _currentValue;

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Text(
            "Pick a number",
            textScaleFactor: 1.5,
            textAlign: TextAlign.center,
            style: new TextStyle(color: Colors.black),
          ),
          new NumberPicker.integer(
              initialValue: _currentValue,
              minValue: -50,
              maxValue: 50,
              onChanged: (newValue) =>
                  setState(() => _currentValue = newValue)),
//            new Text("Current number: $_currentValue"),
        ],
      ),
    );
  }
}


class MatrixSectionSolve extends StatefulWidget {
//  final Matrix solvedMatrix; //provided by algo
//  final ListQueue traceBackStack;
  final String dbSeq, querySeq;

  SeqAlignment seqAlignmentAlgorithm;

  MatrixSectionSolve(this.seqAlignmentAlgorithm, this.querySeq, this.dbSeq);

  @override
  _MatrixStateSolve createState() =>
      new _MatrixStateSolve(querySeq, dbSeq, seqAlignmentAlgorithm);
}

class _MatrixStateSolve extends State<MatrixSectionSolve> {
  int numRows, numCols, cRow = 2, cCol = 2;
  List<List<String>> matrixValues;
  Matrix solutionMatrix;
  String dbSeq, querySeq;


  _MatrixStateSolve(this.querySeq, this.dbSeq, SeqAlignment seqAlignmentAlgorithm) {
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

  int getUserInput(){
    return key.currentState.currentValue;
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
        textScaleFactor: 2.0,
        textAlign: TextAlign.center,
        style: new TextStyle(color: textColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        new Row(mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: buildRows(),
              ),
              new Expanded(
                  child: new Center(
                    child: new Column(
                        children: <Widget>[
                          new NumberPickerSection(key: key),
                          new FloatingActionButton(
                            onPressed: () {
                              updateMatrix();
                            },
                            tooltip: 'Next',
                            child: new Icon(Icons.navigate_next),
                          ),
                        ]
                    ),
                  )
              )
            ]),
      ],
    );
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

  Widget getTextView(String matrixValue, int row, int col) {

    if(row == cRow && col == cCol)
      return buildHighlightedText(matrixValue);
    if((row == cRow-1 && col == cCol-1) || (row == cRow && col == cCol-1) || (row == cRow-1 && col == cCol))
      return buildNeighborText(matrixValue);

    return buildDisabledText(matrixValue);
  }

  Row buildRow(int row) {
//    TextEditingController _controller;
    List<Text> texts = new List();
    for (int col = 0; col < numCols; col++) {
//      _controller = new TextEditingController();
      texts.add(getTextView( matrixValues[row][col], row, col,));
    }
    return new Row(children: texts);
  }

  updateMatrix() {
    if (cRow >= numRows) return;
    setState(() {
      cCol++;
      if (cCol > numCols) {
        cCol = 3;
        cRow++;
      }
      if (cRow >= numRows) {
        showDialog<Null>(
          context: context,
          barrierDismissible: false, // user must tap button!
          child: new AlertDialog(
            title: new Text('Great Work!'),
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  new Text('You have now learnt to solve sequence alignment problems.'),
                  new Text('Try tracing back the sequence.')
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }

      var result = solutionMatrix.getScore(cRow-1, cCol - 2).toString();
      var input = getUserInput().toString();
      if(input!=result){
        Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text('Wrong input. Please try again!.'),
        ));
        cCol--;
      }
      else{
        matrixValues[cRow][cCol-1] = input;
      }
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

class SolvePageDetails extends StatelessWidget {
//StatefulWidget {
  SolvePageDetails({Key key, this.seqAlgorithm, this.matrixSize}) : super(key: key);

  final String seqAlgorithm;
  final int matrixSize;

//for scoring section
  int leftScore, upScore, rightScore, upAdd, leftAdd, diagAdd;
  bool isAMatch;
  int _currentValue = 1;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Solve "+seqAlgorithm+" Sequence Alignment"),
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Container(
              margin: const EdgeInsets.only(top: 50.0),
              child: new RaisedButton(
                  color: Colors.blue.shade900,
                  child: new Text("Click to view instructions",
                    style: new TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    showModalBottomSheet<Null>(context: context, builder: (BuildContext context) {
                      return new Container(
                          child: new Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: new Text('Select number from number picker. Click next to verify and proceed.',
                                  textAlign: TextAlign.center,
                                  style: new TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontSize: 24.0
                                  )
                              )
                          )
                      );
                    });
                  }
              )
          ),
          new Container(
            margin: const EdgeInsets.only(top: 100.0),
            child: new MatrixSectionSolve(new GlobalAlignment(-1, new SimilarityMatrix(), "AB", "CB"), "AB", "CB"),
          ),
        ],
      ),
    );
  }
}