import 'package:biproject/algorithms/models/cell.dart';
import 'package:biproject/algorithms/seq_alignment.dart';

class Matrix {
  int numRows, numCols;
  var cells = new List<List<Cell>>();

  Matrix(this.numRows, this.numCols){

    for (int row = 0; row < numRows; row++) {
      var rowMatrix = new List<Cell>();
      for (int col = 0; col < numCols; col++) {
        rowMatrix[col]  = new Cell(row, col);
      }
      cells[row] = rowMatrix;
    }
  }

  void setScoreOfCell(int row, col, int score)=> cells[row][col].score = score;

  void setTracebackCellFor(int row, int col, int tbcrow, int tbcCol, side side) {
     Cell cell = cells[row][col];
     cell.tracebackCell = cells[tbcrow][tbcCol];
     cell.tbSide = side;
  }

  int getScore(int row, int col) => cells[row][col].score;

  Cell getCell(int row, int col) => cells[row][col];





}

