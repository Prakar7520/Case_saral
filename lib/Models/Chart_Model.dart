import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';

class Chart_Model{

  final String days;
  final int no_of_cases;
  final charts.Color barColor;

  Chart_Model({
    @required this.no_of_cases,
    @required this.days,
    @required this.barColor
  });




}