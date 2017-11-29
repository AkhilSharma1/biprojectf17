import 'dart:collection';

import 'package:biproject/algorithms/models/cell.dart';
import 'package:biproject/algorithms/models/result.dart';
import 'package:biproject/algorithms/seq_alignment.dart';


class GlobalAlignment extends SeqAlignment{
  GlobalAlignment(AlgoType algoType, int gapPenalty, similarityMatrix, String x, String y)
      : super(algoType, gapPenalty, similarityMatrix,x,y);


  @override
  void initializeGapPenaltyRowColumn() {

    //header row
    for (int col = 1; col < matrix.numCols; col++) {
      matrix.setScoreOfCell(0, col, gapPenalty*col);
      matrix.setTracebackCellFor(0, col, 0,col-1, side.left);
    }

    //header col
    for (int row = 1; row < matrix.numRows; row++) {
      matrix.setScoreOfCell(row, 0, gapPenalty*row);
      matrix.setTracebackCellFor(row, 0, row-1, 0, side.up);
    }
  }

  void fillScore(int row, int col) {

    int leftScore = matrix.getScore(row, col-1);
    int upScore = matrix.getScore(row-1, col);
    int diagScore = matrix.getScore(row-1, col-1);
    String queryChar = getQueryChar(row);
    String dbChar = getDBChar(row);

    int scoreFromLeft = leftScore + gapPenalty;
    int scoreFromUp = upScore + gapPenalty;
    int scoreFromDiag  = diagScore + similarityMatrix.getScore(queryChar,dbChar);

    if(scoreFromLeft >=scoreFromUp && scoreFromLeft>=scoreFromDiag){
      matrix.setScoreOfCell(row, col, scoreFromLeft);
      matrix.setTracebackCellFor(row, col, row, col-1, side.left);

    }else if(scoreFromUp >=scoreFromLeft && scoreFromUp>=scoreFromDiag){
      matrix.setScoreOfCell(row, col, scoreFromUp);
      matrix.setTracebackCellFor(row, col, row-1, col, side.up);

    }else{
      matrix.setScoreOfCell(row, col, scoreFromDiag);
      matrix.setTracebackCellFor(row, col, row-1, col-1, side.diag);
    }
  }

  @override
  void traceback() {
    int row = numRows - 1, col =  numCols - 1;

    ListQueue<Cell> tracebackStack = new ListQueue<Cell>();

    Cell cell = matrix.getCell(row, col);

    do{
      tracebackStack.addFirst(cell);

      row = cell.tracebackCell.row;
      col = cell.tracebackCell.col;
    }while(row!=0 && col !=0);

    List<String> seqs = calculateAlignedSeq(tracebackStack);
    alignedQuerySeq = seqs[0];
    alignedDBSeq = seqs[1];
  }


  
}