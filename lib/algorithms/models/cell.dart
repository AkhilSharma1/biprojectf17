import 'package:biproject/algorithms/seq_alignment.dart';

class Cell{

   int score;
   int row;
   int col;
   side tbSide;
   Cell tracebackCell; //cell from which the score came

  Cell(this.row, this.col);

}

