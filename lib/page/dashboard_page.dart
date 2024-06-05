import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:beauty_pro/services/user_authentication.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _userAuthentication = UserAuthentication();
  late String userID = _userAuthentication.getCurrentUserId() ?? "";

  Map<int, Map<String, dynamic>> _monthlySummary = {};
  int _totalDocs = 0;
  double _totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    loadYearlySummary();
    loadMonthlySummary();
  }

  void loadYearlySummary() async {
    final result = await _userAuthentication.fetchYearlySummary(userID);
    setState(() {
      _totalDocs = result['totalDocs'];
      _totalPrice = result['totalPrice'];
    });
  }

  void loadMonthlySummary() async {
    final result = await _userAuthentication.fetchMonthlySummary(userID);
    setState(() {
      _monthlySummary = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, title: "Dashboard"),
      body: Column(
        children: [
          Expanded(
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              title: ChartTitle(text: 'Gráfico de faturamento'),
              legend: Legend(isVisible: true),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <CartesianSeries<_SalesData, String>>[
                LineSeries<_SalesData, String>(
                  dataSource: _monthlySummary.keys.map((month) {
                    return _SalesData(month.toString(), _monthlySummary[month]!['totalPrice'] ?? 0.0);
                  }).toList(),
                  xValueMapper: (_SalesData sales, _) => sales.year,
                  yValueMapper: (_SalesData sales, _) => sales.sales,
                  name: 'Faturamento',
                  dataLabelSettings: DataLabelSettings(isVisible: true),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quantidade Total de Atendimentos no Ano: $_totalDocs'),
                Text('Faturamento Total no Ano: R\$ $_totalPrice'),
                SizedBox(height: 20),
                Text('Resumo Mensal:'),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: _monthlySummary.keys.length,
                    itemBuilder: (context, index) {
                      int month = _monthlySummary.keys.elementAt(index);
                      double totalPrice = _monthlySummary[month]!['totalPrice'] ?? 0.0;
                      int totalDocs = _monthlySummary[month]!['totalDocs'] ?? 0;
                      return ListTile(
                        title: Text('Mês: $month'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Faturamento: R\$ $totalPrice'),
                            Text('Quantidade de Atendimentos: $totalDocs'),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
    backgroundColor: const Color.fromRGBO(39, 144, 176, 1),
    title: Text(
      title,
      style: const TextStyle(color: Colors.white),
    ),
  );
}
