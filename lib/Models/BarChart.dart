import 'package:intl/intl.dart';
import 'package:ver2/Components/SplashScreen.dart';
import 'package:ver2/Models/Chart_Model.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:ver2/Models/MyCaseList.dart';

class BarChart extends StatefulWidget {

  final List<MyCaseList> graphDate;

  const BarChart({this.graphDate});

  @override
  _BarChartState createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> {
  List<Chart_Model> data = [];

  String dateTwo = DateFormat('dd/MM/yyyy').format(DateTime.now().add(Duration(days: 1)));
  String dateThree = DateFormat('dd/MM/yyyy').format(DateTime.now().add(Duration(days: 2)));
  String dateFour = DateFormat('dd/MM/yyyy').format(DateTime.now().add(Duration(days: 3)));
  String dateFive = DateFormat('dd/MM/yyyy').format(DateTime.now().add(Duration(days: 4)));
  String today = DateFormat('dd/MM/yyyy').format(DateTime.now());

  List<Chart_Model> createGraph(){

    List<String> graphDateData = [];
    int count1 = 0;
    int count2 = 0;
    int count3 = 0;
    int count4 = 0;
    int count5 = 0;

    for(var item in widget.graphDate){
      if(item.assign_to == userLoggedIn ){
        if(item.hearing_date == today || item.hearing_date == dateTwo || item.hearing_date == dateThree || item.hearing_date == dateFour || item.hearing_date == dateFive){
          graphDateData.add(item.hearing_date);
        }
      }
    }

    for(var value in graphDateData){
      if(value == DateFormat('dd/MM/yyyy').format(DateTime.now())){
        count1 = count1+1;
      }if(value == DateFormat('dd/MM/yyyy').format(DateTime.now().add(Duration(days: 1)))){
        count2 = count2+1;
      }if(value == DateFormat('dd/MM/yyyy').format(DateTime.now().add(Duration(days: 2)))){
        count3 = count3+1;
      }if(value == DateFormat('dd/MM/yyyy').format(DateTime.now().add(Duration(days: 3)))){
        count4 = count4+1;
      }if(value == DateFormat('dd/MM/yyyy').format(DateTime.now().add(Duration(days: 4)))){
        count5 = count5+1;
      }
    }

    final List<Chart_Model> data = [
      Chart_Model(no_of_cases: count1, days: DateFormat('d').format(DateTime.now()), barColor: charts.ColorUtil.fromDartColor(Colors.blue)),
      Chart_Model(no_of_cases: count2, days: DateFormat('d').format(DateTime.now().add(Duration(days: 1))), barColor: charts.ColorUtil.fromDartColor(Colors.red)),
      Chart_Model(no_of_cases: count3, days: DateFormat('d').format(DateTime.now().add(Duration(days: 2))), barColor: charts.ColorUtil.fromDartColor(Colors.black)),
      Chart_Model(no_of_cases: count4, days: DateFormat('d').format(DateTime.now().add(Duration(days: 3))), barColor: charts.ColorUtil.fromDartColor(Colors.purpleAccent)),
      Chart_Model(no_of_cases: count5, days: DateFormat('d').format(DateTime.now().add(Duration(days: 4))), barColor: charts.ColorUtil.fromDartColor(Colors.green)),
    ];
    return data;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    List<Chart_Model> data;

    setState(() {
      data = createGraph();
    });

    List<charts.Series<Chart_Model,String>> series = [
      charts.Series(
          id: "days",
          data: data,
          domainFn: (Chart_Model series, _) => series.days,
          measureFn: (Chart_Model series, _) => series.no_of_cases,
          colorFn: (Chart_Model series, _) => series.barColor
      )
    ];

    return Container(
      height: 400,
      width: size.width*0.9,
      padding: EdgeInsets.all(20),
      child: Card(
        elevation: 8,
        child: Column(
          children: [
            Text("Cases Per Day",style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(child: charts.BarChart(series,animate: true,),),
            SizedBox(height: 10,),
            Text(DateFormat('MMMM').format(DateTime.now())),
            SizedBox(height: 8,)
          ],
        ),
      ),
    );
  }
}
