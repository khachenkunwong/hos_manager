import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Details extends StatefulWidget {
  const Details({super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late TooltipBehavior _tooltipBehavior;
  late SelectionBehavior _selectionBehavior;
  late Future<String> testString;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tooltipBehavior =
        TooltipBehavior(enable: true, header: "", canShowMarker: false);
    _selectionBehavior = SelectionBehavior(enable: true);
  }

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = <ChartData>[
      ChartData('สัปดาห์ที่ 1', 128, 129, 101, 20),
      ChartData('สัปดาห์ที่ 2', 123, 92, 93, 80),
      ChartData('สัปดาห์ที่ 3', 107, 106, 90, 120),
      ChartData('สัปดาห์ที่ 4', 87, 95, 71, 100),
      ChartData('สัปดาห์ที่ 5', 87, 95, 71, 100),
      ChartData('สัปดาห์ที่ 6', 87, 95, 71, 100),
      ChartData('สัปดาห์ที่ 7', 107, 106, 90, 120),
      ChartData('สัปดาห์ที่ 8', 87, 95, 71, 100),
      ChartData('สัปดาห์ที่ 9', 87, 95, 71, 100),
      ChartData('สัปดาห์ที่ 10', 87, 95, 71, 100),
    ];
    return Scaffold(
        body: SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: AlignmentDirectional(-1, 0),
            child: InkWell(
              onTap: () async {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.chevron_left,
                color: Colors.black,
                size: 60,
              ),
            ),
          ),
          Center(
            child: Container(
                // width: MediaQuery.of(context).size.width * 0.80,
                child: SfCartesianChart(
                    title: ChartTitle(
                      text: "arms",
                      textStyle: TextStyle(
                        fontFamily: "Mitr",
                        fontSize: 16,
                        color: Color(0xFFF727272),
                      ),
                    ),
                    loadMoreIndicatorBuilder:
                        (BuildContext context, ChartSwipeDirection direction) {
                      return getLoadMoreViewBuilder(context, direction);
                    },
                    plotAreaBorderWidth: 0,
                    enableMultiSelection: true,
                    tooltipBehavior: _tooltipBehavior,
                    primaryXAxis: CategoryAxis(
                        arrangeByIndex: false,
                        majorGridLines: const MajorGridLines(width: 0)),
                    primaryYAxis: NumericAxis(
                        axisLine: const AxisLine(width: 0),
                        labelFormat: "{value}",
                        rangePadding: ChartRangePadding.normal,
                        majorTickLines: const MajorTickLines(width: 0)),
                    palette: <Color>[
                  Color(0xFFF56CCF2),
                  Color(0xFFF9B51E0),
                  Color(0xFFF1033FD),
                  Color(0xFFF2C94C)
                ],
                    series: <CartesianSeries>[
                  ColumnSeries<ChartData, String>(
                      animationDuration: 1500,
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        textStyle: TextStyle(
                          fontFamily: "Mitr",
                          fontSize: 16,
                          color: Color(0xFFF727272),
                        ),
                      ),
                      selectionBehavior: _selectionBehavior,
                      dataSource: chartData,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                      name: "ชั่วโมงการทำงาน"),
                  ColumnSeries<ChartData, String>(
                      animationDuration: 1500,
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        textStyle: TextStyle(
                          fontFamily: "Mitr",
                          fontSize: 16,
                          color: Color(0xFFF727272),
                        ),
                      ),
                      selectionBehavior: _selectionBehavior,
                      dataSource: chartData,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y1,
                      name: "ค่าเฉลีย"),
                  ColumnSeries<ChartData, String>(
                      animationDuration: 1500,
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        textStyle: TextStyle(
                          fontFamily: "Mitr",
                          fontSize: 16,
                          color: Color(0xFFF727272),
                        ),
                      ),
                      selectionBehavior: _selectionBehavior,
                      dataSource: chartData,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y2,
                      name: "มัธยฐาน"),
                  ColumnSeries<ChartData, String>(
                      animationDuration: 1500,
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        textStyle: TextStyle(
                          fontFamily: "Mitr",
                          fontSize: 16,
                          color: Color(0xFFF727272),
                        ),
                      ),
                      selectionBehavior: _selectionBehavior,
                      dataSource: chartData,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y3,
                      name: "ฐานนิยม")
                ])),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 10, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 25.0,
                        height: 25.0,
                        color: Color(0xFFF56CCF2),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(
                          "ชั่วโมงการทำงาน",
                          style: GoogleFonts.mitr(
                              fontSize: 24, color: Color(0xFFF727272)),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 25.0,
                        height: 25.0,
                        color: Color(0xFFF9B51E0),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(
                          "ค่าเฉลีย",
                          style: GoogleFonts.mitr(
                              fontSize: 24, color: Color(0xFFF727272)),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 25.0,
                        height: 25.0,
                        color: Color(0xFFF1033FD),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(
                          "มัธยฐาน",
                          style: GoogleFonts.mitr(
                              fontSize: 24, color: Color(0xFFF727272)),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 25.0,
                        height: 25.0,
                        color: Color(0xFFF2C94C),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(
                          "ฐานนิยม",
                          style: GoogleFonts.mitr(
                              fontSize: 24, color: Color(0xFFF727272)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Widget getLoadMoreViewBuilder(
      BuildContext context, ChartSwipeDirection direction) {
    if (direction == ChartSwipeDirection.end) {
      return FutureBuilder<String>(
        // ใช่สำหรับทดสอบ
        future: testString,

        /// Adding data by updateDataSource method
        builder: (BuildContext futureContext, AsyncSnapshot<String> snapShot) {
          return snapShot.connectionState != ConnectionState.done
              ? const CircularProgressIndicator()
              : SizedBox.fromSize(size: Size.zero);
        },
      );
    } else {
      return SizedBox.fromSize(size: Size.zero);
    }
  }
}

class ChartData {
  ChartData(this.x, this.y, this.y1, this.y2, this.y3);
  final String x;
  final double? y;
  final double? y1;
  final double? y2;
  final double? y3;
}
