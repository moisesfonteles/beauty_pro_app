import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class DashboardPage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<_SalesData> data = [
    _SalesData('Jan', 35),
    _SalesData('Feb', 28),
    _SalesData('Mar', 34),
    _SalesData('Apr', 32),
    _SalesData('May', 40)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(context, title: "Dashboard"),
        body: Column(children: [
          
          SfCartesianChart(
              primaryXAxis: const CategoryAxis(),
              
              title: const ChartTitle(text: 'Gráfico de faturamento'),
              
              legend: const Legend(isVisible: true),
             
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <CartesianSeries<_SalesData, String>>[
                LineSeries<_SalesData, String>(
                    dataSource: data,
                    xValueMapper: (_SalesData sales, _) => sales.year,
                    yValueMapper: (_SalesData sales, _) => sales.sales,
                    name: 'Sales',
                    
                    dataLabelSettings: const DataLabelSettings(isVisible: true))
              ]),
          
        ]));
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}

AppBar customAppBar(BuildContext context, {String title = ''}) {
  return AppBar(
    centerTitle: true,
    backgroundColor: const Color.fromRGBO(20, 28, 95, 1),
    title: Text(
      title,
      style: const TextStyle(color: Colors.white),
    ),
  );
}