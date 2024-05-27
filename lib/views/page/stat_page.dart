import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:smig_app/services/stat_service.dart';

import '../../widgets/custom_bottom_app_bar.dart';
import '../../widgets/custom_top_app_bar.dart';

class StatPage extends StatefulWidget {
  @override
  _StatPageState createState() => _StatPageState();
}

class _StatPageState extends State<StatPage> {
  late StatService statService;

  @override
  void initState() {
    super.initState();
    statService = StatService();
  }

  final List<Color> chartColors = [
    const Color(0x5F03989E),
    const Color(0x5FFFBD59),
    const Color(0x5FFA93C6),
    const Color(0x5F9659FF),
    const Color(0x5F59FF9B),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomTopAppBar(),
      bottomNavigationBar: const CustomBottomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/gouv/marianne.png', width: 40, height: 40),
            const Text('Dashboard statistiques',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF015E62),
              ),
            ),
            SizedBox(height: 20,),
            FutureBuilder(
              future: statService.fetchStatsByCategoryPerMonth(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                  var stats = snapshot.data as List<dynamic>;
                  List<PieChartSectionData> sections = stats.map<PieChartSectionData>((stat) {
                    int colorIndex = stats.indexOf(stat) % chartColors.length;
                    return PieChartSectionData(
                      color: chartColors[colorIndex],
                      value: stat['nombre'].toDouble(),
                      radius: 50,
                    );
                  }).toList();

                  return Column(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Text('Répartition par Catégorie',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      Container(
                        height: 220,
                        child: PieChart(
                          PieChartData(
                            sections: sections,
                            centerSpaceRadius: 40,
                            sectionsSpace: 2,
                          ),
                        ),
                      ),
                      Wrap(
                        alignment: WrapAlignment.start,
                        spacing: 8.0, // gap between adjacent chips
                        runSpacing: 1.0, // gap between lines
                        children: stats.asMap().entries.map((entry) {
                          int idx = entry.key;
                          var stat = entry.value;
                          return Chip(
                            backgroundColor: chartColors[idx % chartColors.length],
                            label: Text('${stat['nom']}'),
                          );
                        }).toList(),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                return CircularProgressIndicator();
              },
            ),
            SizedBox(height: 20,),
            FutureBuilder(
              future: statService.fetchStatsByTagPerMonth(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                  var tags = snapshot.data as List<dynamic>;
                  List<BarChartGroupData> barGroups = [];
                  for (int i = 0; i < tags.length; i++) {
                    barGroups.add(
                      BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            color: chartColors[i % chartColors.length], toY: tags[i]['nombre'].toDouble(),
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Text('Répartition par Tag',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          height: 300,
                          width: 360,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: 10,
                              barGroups: barGroups,
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                    getTitlesWidget: (value, meta) {
                                      final index = value.toInt();
                                      return SideTitleWidget(
                                        axisSide: meta.axisSide,
                                        space: 8.0,
                                        child: Text(tags[index]['nom']),
                                      );
                                    },
                                  ),
                                ),
                                leftTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                return CircularProgressIndicator();
              },
            ),
            buildTopStatGraph(statService.fetchTopResourcesInFavorites(), 'Top Ressources en Favoris', 'ressource'),
            buildTopStatGraph(statService.fetchTopCreators(), 'Top Créateur de Ressource', 'createur'),

          ],
        ),
      ),
    );
  }

  Widget buildTopStatGraph(Future<dynamic> fetchFunction, String title, String objet) {
    return FutureBuilder(
      future: fetchFunction,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          var data = snapshot.data as List<dynamic>;
          List<BarChartGroupData> barGroups = [];
          for (int i = 0; i < data.length; i++) {
            barGroups.add(
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    color: chartColors[i % chartColors.length], toY: data[i]['nombre'].toDouble(),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ),
              Container(
                height: 300,
                width: 360,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: data.map((e) => e['nombre']).reduce((value, element) => value > element ? value : element).toDouble(),
                    barGroups: barGroups,
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              space: 8.0,
                              child: Text(data[index]['${objet}']),
                            );
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return CircularProgressIndicator();
      },
    );
  }
}
