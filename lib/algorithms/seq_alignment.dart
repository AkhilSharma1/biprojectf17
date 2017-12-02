import 'dart:collection';

import 'package:biproject/algorithms/matrix.dart';
import 'package:biproject/algorithms/models/cell.dart';

abstract class SeqAlignment {
  var similarityMatrix;
  int gapPenalty, numRows, numCols, alignmentScore;
  Matrix matrix;
  String querySeq, dbSeq, alignedQuerySeq, alignedDBSeq;

  SeqAlignment(this.gapPenalty, this.similarityMatrix, this.querySeq, this.dbSeq);

  void solve() {
    numRows = querySeq.length + 1; //We have one extra row and column
    numCols = dbSeq.length + 1; //We have one extra row and column
    matrix = new Matrix(numRows, numCols);
    _initializeGapPenaltyRowColumn();
    _fillMatrix();
    _traceback();
  }

  void _initializeGapPenaltyRowColumn();

  void _fillMatrix() {
    int xMin = 1, yMin = 1;

    for (int row = xMin; row < numRows; row++) {
      for (int col = yMin; col < numCols; col++) {
        fillScore(row, col);
      }
    }

  }

  List<String> calculateAlignedSeq(ListQueue<Cell> tracebackStack){
    StringBuffer alignedQuerySeq = new StringBuffer(), alignedDBSeq = new StringBuffer();
    while(!tracebackStack.isEmpty){
      Cell cell = tracebackStack.removeFirst();

      String indelChar = '.';
      String queryChar = getQueryChar(cell.row);
      String dbChar = getDBChar(cell.col);

      switch (cell.tbSide){
        case side.left:
          alignedQuerySeq.write(indelChar);
          alignedDBSeq.write(dbChar);
          break;
        case side.up:
          alignedQuerySeq.write(queryChar);
          alignedDBSeq.write(indelChar);
          break;
        case side.diag:
          alignedQuerySeq.write(queryChar);
          alignedDBSeq.write(dbChar);
          break;
      }
    }

    List<String> seqs = [alignedQuerySeq.toString(), alignedDBSeq.toString()];

    return  seqs;
  }

  void fillScore(int row, int col);

  String getQueryChar(int row) => row>0?querySeq[row-1]:'.';

  String getDBChar(int col) {return col>0?dbSeq[col-1]:'.';}

  void _traceback();


}

enum AlgoType { global, local }
enum side { left, up, diag }
