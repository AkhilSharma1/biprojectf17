import 'dart:collection';

import 'package:biproject/algorithms/models/cell.dart';
import 'package:biproject/algorithms/seq_alignment.dart';

class LocalAlignment extends SeqAlignment{
  LocalAlignment(  int gapPenalty, similarityMatrix,x,y) : super( gapPenalty, similarityMatrix,x,y);


  @override
  void initializeGapPenaltyRowColumn() {

    //header row
    for (int col = 1; col < matrix.numCols; col++) {
      matrix.setTracebackCellFor(0, col, 0, col-1, side.left);
    }

    //header col
    for (int row = 1; row < matrix.numRows; row++) {
      matrix.setTracebackCellFor(row, 0, row-1, 0, side.up);
    }
  }


  @override
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
      matrix.setScoreOfCell(row, col, scoreFromLeft>0?scoreFromLeft:0);//local
      matrix.setTracebackCellFor(row, col, row, col-1, side.left);

    }else if(scoreFromUp >=scoreFromLeft && scoreFromUp>=scoreFromDiag){
      matrix.setScoreOfCell(row, col, scoreFromUp>0?scoreFromUp:0);
      matrix.setTracebackCellFor(row, col, row-1, col, side.up);

    }else{
      matrix.setScoreOfCell(row, col, scoreFromDiag>0?scoreFromDiag:0);
      matrix.setTracebackCellFor(row, col, row-1, col-1, side.diag);
    }

  }

  @override
  void traceback() {
//    int row = numRows - 1, col =  numCols - 1;

    ListQueue<Cell> tracebackStack = new ListQueue<Cell>();

    Cell cell = getHighestScoreCell();

    do{
      tracebackStack.addFirst(cell);
      cell = cell.tracebackCell;
    }while(cell.score>0);

    List<String> seqs = calculateAlignedSeq(tracebackStack);
    alignedQuerySeq = seqs[0];
    alignedDBSeq = seqs[1];
  }

  Cell getHighestScoreCell() {
    Cell highestScoreCell = matrix.getCell(0, 0);
    for (int row = 1; row < numRows; row++) {
      for (int col = 1; col < numCols; col++) {
        var cell = matrix.getCell(row, col);
        if(cell.score>=highestScoreCell.score)
          highestScoreCell = cell;
      }
    }

    return highestScoreCell;
  }


}