import 'package:flutter/material.dart';
import 'package:mobile_pos/constant.dart';

import 'chart_data.dart';
import 'package:mobile_pos/model/dashboard_overview_model.dart';
import 'package:fl_chart/fl_chart.dart';


class DashboardChart extends StatefulWidget {
  const DashboardChart({Key? key, required this.model}) : super(key: key);

  final DashboardOverviewModel model;

  @override
  State<DashboardChart> createState() => _DashboardChartState();
}
//
// class _DashboardChartState extends State<DashboardChart> {
//   List<ChartData> chartData = [];
//
//   @override
//   void initState() {
//     super.initState();
//     getData(widget.model);
//   }
//
//   void getData(DashboardOverviewModel model) {
//     chartData = [];
//     for (int i = 0; i < model.data!.sales!.length; i++) {
//       chartData.add(ChartData(
//         model.data!.sales![i].date!,
//         model.data!.sales![i].amount!.toDouble(),
//         model.data!.purchases![i].amount!.toDouble(),
//       ));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Container(
//           color: Colors.white,
//           // padding: const EdgeInsets.all(16.0),
//           child: Stack(
//             alignment: Alignment.topRight,
//             children: [
//               BarChart(
//                 BarChartData(
//                   alignment: BarChartAlignment.spaceAround,
//                   maxY: _getMaxY(),
//                   barTouchData: BarTouchData(enabled: false),
//                   titlesData: FlTitlesData(
//                     show: true,
//                     bottomTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         getTitlesWidget: _getBottomTitles,
//                         reservedSize: 42,
//                       ),
//                     ),
//                     rightTitles: const AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: false,
//                       ),
//                     ),
//                     topTitles: const AxisTitles(
//                       sideTitles: SideTitles(showTitles: false,reservedSize: 20)
//                     ),
//                     leftTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         getTitlesWidget: _getLeftTitles,
//                         reservedSize: 50,
//                       ),
//                     ),
//                   ),
//                   borderData: FlBorderData(
//                     show: false,  // Ensure borders are shown
//                   ),
//                   gridData: FlGridData(
//                     show: true,
//                     drawVerticalLine: false,
//                     drawHorizontalLine: true,
//                     getDrawingHorizontalLine: (value) {
//                       return const FlLine(
//                         color: Color(0xffD1D5DB),
//                         dashArray: [4, 4],
//                         strokeWidth: 1,
//                       );
//                     },
//                   ),
//                   barGroups: _buildBarGroups(),
//                 ),
//
//               ),
//         Column(
//           children: [
//             CustomPaint(
//               size:  Size(
//                   MediaQuery.of(context).size.width-100, 0.1), // Adjust size as needed
//               painter: DashedBarPainter(
//                 barHeight: 1,
//                 barColor: const Color(0xffD1D5DB),
//                 dashWidth: 4,
//                 dashSpace: 4,
//               )),
//             // const SizedBox(),
//             const Spacer(),
//             Padding(
//               padding: const EdgeInsets.only(bottom: 42),
//               child: CustomPaint(
//                   size:  Size(
//                       MediaQuery.of(context).size.width-100, 0.1), // Adjust size as needed
//                   painter: DashedBarPainter(
//                     barHeight: 1,
//                     barColor: const Color(0xffD1D5DB),
//                     dashWidth: 4,
//                     dashSpace: 4,
//                   )),
//             ),
//           ],
//         ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   double _getMaxY() {
//     double maxY = 0;
//     for (var data in chartData) {
//       maxY = maxY > data.y ? maxY : data.y;
//       maxY = maxY > data.y1 ? maxY : data.y1;
//     }
//     return maxY + 10;
//   }
//
//   List<BarChartGroupData> _buildBarGroups() {
//     return chartData.asMap().entries.map((entry) {
//       int index = entry.key;
//       ChartData data = entry.value;
//
//       return BarChartGroupData(
//         x: index,
//         barRods: [
//           BarChartRodData(
//             toY: data.y,
//             color: Colors.green,
//             width: 6,
//             borderRadius: const BorderRadius.all(Radius.circular(10)),
//           ),
//           BarChartRodData(
//             toY: data.y1,
//             color: kMainColor,
//             width: 6,
//             borderRadius: const BorderRadius.all(Radius.circular(10)),
//           ),
//         ],
//         barsSpace: 8,
//       );
//     }).toList();
//   }
//
//   Widget _getBottomTitles(double value, TitleMeta meta) {
//     const style = TextStyle(
//       color: Color(0xff4D4D4D),
//       fontSize: 12,
//     );
//
//     String text = chartData[value.toInt()].x;
//
//     return SideTitleWidget(
//       axisSide: meta.axisSide,
//       space: 8,
//       child: Text(text, style: style),
//     );
//   }
//
//   Widget _getLeftTitles(double value, TitleMeta meta) {
//     return SideTitleWidget(
//       axisSide: meta.axisSide,
//       child: Text(
//         value.toInt().toString(),
//         style: const TextStyle(
//           color: Colors.black,
//           fontSize: 12,
//         ),
//       ),
//     );
//   }
// }


class _DashboardChartState extends State<DashboardChart> {
  List<ChartData> chartData = [];

  @override
  void initState() {
    super.initState();
    getData(widget.model);
  }

  void getData(DashboardOverviewModel model) {
    chartData = [];
    for (int i = 0; i < model.data!.sales!.length; i++) {
      chartData.add(ChartData(
        model.data!.sales![i].date!,
        model.data!.sales![i].amount!.toDouble(),
        model.data!.purchases![i].amount!.toDouble(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: chartData.length * 50.0, // Adjust width based on the number of data points
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: _getMaxY(),
                      barTouchData: BarTouchData(enabled: false),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: _getBottomTitles(value, meta),
                              );
                            },
                            reservedSize: 42,
                          ),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: false,
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false, reservedSize: 20),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: _getLeftTitles,
                            reservedSize: _getLeftTitleReservedSize(),
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        drawHorizontalLine: true,
                        getDrawingHorizontalLine: (value) {
                          return const FlLine(
                            color: Color(0xffD1D5DB),
                            dashArray: [4, 4],
                            strokeWidth: 1,
                          );
                        },
                      ),
                      barGroups: _buildBarGroups(),
                    ),
                  ),
                  Column(
                    children: [
                      // CustomPaint(
                      //     size: Size(
                      //         MediaQuery.of(context).size.width - 100, 0.1), // Adjust size as needed
                      //     painter: DashedBarPainter(
                      //       barHeight: 1,
                      //       barColor: const Color(0xffD1D5DB),
                      //       dashWidth: 4,
                      //       dashSpace: 4,
                      //     )),
                      SizedBox(),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 42),
                        child: CustomPaint(
                          size: Size(
                              chartData.length * 50.0 - _getLeftTitleReservedSize(),  // Adjust to match the width of the BarChart exactly
                              0.1
                          ),
                          painter: DashedBarPainter(
                            barHeight: 1,
                            barColor: const Color(0xffD1D5DB),
                            dashWidth: 4,
                            dashSpace: 4,
                          ),
                        ),
                      ),


                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _getMaxY() {
    double maxY = 0;
    for (var data in chartData) {
      maxY = maxY > data.y ? maxY : data.y;
      maxY = maxY > data.y1 ? maxY : data.y1;
    }
    return maxY + 10;
  }

  double _getLeftTitleReservedSize() {
    double maxY = _getMaxY();
    if (maxY < 999) {
      return 32;
    } else if (maxY < 1000) {
      return 35;
    } else if (maxY < 10000) {
      return 54;
    } else {
      return 50; // Add more cases if needed
    }
  }

  List<BarChartGroupData> _buildBarGroups() {
    return chartData.asMap().entries.map((entry) {
      int index = entry.key;
      ChartData data = entry.value;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data.y,
            color: Colors.green,
            width: 6,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          BarChartRodData(
            toY: data.y1,
            color: kMainColor,
            width: 6,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
        ],
        barsSpace: 8,
      );
    }).toList();
  }

  Widget _getBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff4D4D4D),
      fontSize: 12,
    );

    String text = chartData[value.toInt()].x;

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8,
      child: Text(text, style: style),
    );
  }

  Widget _getLeftTitles(double value, TitleMeta meta) {
    // Calculate the maximum y-value in the chart data
    double maxY = _getMaxY();
    // Check if the current value is the maximum; if so, return an empty widget
    if (value == maxY) {
      return const SizedBox.shrink(); // Don't display the highest value
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        value.toInt().toString(),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 12,
        ),
      ),
    );
  }


// Widget _getLeftTitles(double value, TitleMeta meta) {
  //   return SideTitleWidget(
  //     axisSide: meta.axisSide,
  //     child: Text(
  //       value.toInt().toString(),
  //       style: const TextStyle(
  //         color: Colors.black,
  //         fontSize: 12,
  //       ),
  //     ),
  //   );
  // }
}




///---------------------------------dash line-------------------------------

class DashedBarPainter extends CustomPainter {
  final double barHeight;
  final Color barColor;
  final double dashWidth;
  final double dashSpace;

  DashedBarPainter({
    required this.barHeight,
    required this.barColor,
    this.dashWidth = 4.0,
    this.dashSpace = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = barColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = barHeight;

    final dashPath = Path();
    for (double i = 0; i < size.width; i += dashWidth + dashSpace) {
      dashPath.addRect(Rect.fromLTWH(i, 0, dashWidth, size.height));
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


///-----------------------------synfusion data chart--------------------------------


// class NumericAxisChart extends StatefulWidget {
//   const NumericAxisChart({Key? key, required this.model}) : super(key: key);
//
//   final DashboardOverviewModel model;
//
//   @override
//   State<NumericAxisChart> createState() => _NumericAxisChartState();
// }
//
// class _NumericAxisChartState extends State<NumericAxisChart> {
//   final List<ChartData> chartData = [];
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     getData(widget.model);
//     super.initState();
//   }
//
//   getData(DashboardOverviewModel model) {
//     for (int i = 0; i < model.data!.sales!.length; i++) {
//       chartData.add(ChartData(
//           model.data!.sales![i].date!,
//           model.data!.sales![i].amount!.toDouble(),
//           model.data!.purchases![i].amount!.toDouble()));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Container(
//           color: kWhite,
//           child: SfCartesianChart(
//             primaryXAxis: const CategoryAxis(
//               axisLine: AxisLine(width: 0), // Remove bottom axis line
//               majorGridLines: MajorGridLines(width: 0), //// Remove vertical grid lines// Make labels transparent
//               majorTickLines: MajorTickLines(size: 0),
//             ),
//             primaryYAxis: const NumericAxis(
//               axisLine: AxisLine(width: 0), // Remove left axis line
//               majorGridLines: MajorGridLines(
//                 color: Color(0xffD1D5DB),
//                 dashArray: [5, 5], // Creates a dotted line pattern for horizontal grid lines
//               ),
//             ),
//             plotAreaBorderWidth: 0,
//             series: <CartesianSeries<ChartData, String>>[
//               ColumnSeries<ChartData, String>(
//                 dataSource: chartData,
//                 spacing: 0.3,
//                 width: 0.5,
//                 xValueMapper: (ChartData data, _) => data.x,
//                 yValueMapper: (ChartData data, _) => data.y,
//                 name: 'Sales',
//                 dataLabelSettings: const DataLabelSettings(isVisible: false),
//                 color: Colors.green,
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(10),
//                   topRight: Radius.circular(10),
//                   bottomRight: Radius.circular(10),
//                   bottomLeft: Radius.circular(10)
//                 ),
//               ),
//               ColumnSeries<ChartData, String>(
//                 dataSource: chartData,
//                 width: 0.5,
//                 spacing: 0.3,
//                 xValueMapper: (ChartData data, _) => data.x,
//                 yValueMapper: (ChartData data, _) => data.y1,
//                 name: 'Purchase',
//                 color: kMainColor,
//                 dataLabelSettings: const DataLabelSettings(isVisible: false),
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(10),
//                   topRight: Radius.circular(10),
//                   bottomLeft: Radius.circular(10),
//                   bottomRight: Radius.circular(10)
//                 ),
//               ),
//             ],
//           )
//           ,
//         ),
//       ),
//     );
//   }
// }
//
// class ChartData {
//   ChartData(this.x, this.y, this.y1);
//
//   final String x;
//   final double y;
//   final double y1;
// }


