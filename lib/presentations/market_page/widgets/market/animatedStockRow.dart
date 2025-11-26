import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ui_bang_gia/helper/utils.dart';
import 'package:ui_bang_gia/models/stock/stock_model.dart';
import 'package:ui_bang_gia/presentations/market_page/widgets/market/table.dart';

class AnimatedStockRow extends StatefulWidget {
  final Stock stock;
  final int rowIndex;
  final int totalRow;
  const AnimatedStockRow({super.key, required this.stock, required this.rowIndex, required this.totalRow});

  @override
  State<AnimatedStockRow> createState() => _AnimatedStockRowState();
}

class _AnimatedStockRowState extends State<AnimatedStockRow> {
  Timer? _flashTimer;
  final Map<int, CellFlashState> _flashCells ={};
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _startFlashAnimation();
  }

  @override
  void dispose() {
    _flashTimer?.cancel();
    super.dispose();
  }

  void _startFlashAnimation(){
    _flashTimer = Timer.periodic(Duration(milliseconds: 500 + _random.nextInt(500)), (timer){
      if(!mounted) return;

      final numCellsToFlash = 1 + _random.nextInt(2);

      List<int> flashCells = [3, 4, 5, 6, 7, 8, 9, 10, 11,12, 13, 14];

      flashCells = flashCells.where((index) {
        return cellHasValue(widget.stock,index);
      }).toList();

      setState(() {
        _flashCells.removeWhere((key,value) => DateTime.now().difference(value.timestamp).inMilliseconds > 200);

      for(int i= 0; i<numCellsToFlash; i++){
        if(flashCells.isEmpty) break;

        final cellIndex = flashCells[_random.nextInt(flashCells.length)];
        flashCells.remove(cellIndex);

        Color flashColor;
        int flashLine = 0;

        if(cellIndex == 11 || cellIndex == 14){
          flashColor = Color(0xFFFF9F41);
          flashLine =_random.nextInt(3);
        }else{
          flashColor = getFlashColorForCell(widget.stock,cellIndex);

          final rand = _random.nextInt(10);
          if(rand <7){
            flashLine = 1 + _random.nextInt(2);
          }else{
            flashLine = 0;
          }
        }

        _flashCells[cellIndex] = CellFlashState(
            stockSymbol: widget.stock.symbol,
            cellIndex: cellIndex,
            flashLine: flashLine,
            flashColor: flashColor,
            timestamp: DateTime.now());
      }
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return buildRow(widget.stock, widget.rowIndex, widget.totalRow, _flashCells);
  }
}

class CellFlashState{
  final String stockSymbol;
  final int cellIndex;
  final int flashLine;
  final Color flashColor;
  final DateTime timestamp;

  CellFlashState({required this.stockSymbol, required this.cellIndex, required this.flashLine, required this.flashColor, required this.timestamp});
}
