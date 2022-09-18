import 'package:expandable/expandable.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../backend/api_requests/api_calls.dart';
import '../backend/pubilc_.dart';
import '../custom_code/actions/notifica.dart';

import '../flutter_flow/flutter_flow_choice_chips.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../model/group_manager_model.dart';
import '../model/not_manager_group_model.dart';
import 'creategroup_widget.dart';
import 'itemnotmanagegroup.dart';
import 'menuitem.dart';

class ListOrder extends StatefulWidget {
  const ListOrder({Key? key}) : super(key: key);

  @override
  _ListOrderState createState() => _ListOrderState();
}

class _ListOrderState extends State<ListOrder> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ApiCallResponse? logoutCallOutput;
  int index = 0;
  int indexGroup = 0;
  int indexselete = 0;
  late String fristname;
  late String lastname;
  late String iduser;
  // อ่านไฟล์ json
  var contents;
  bool stataShowManagerGroup = false;

  // เก็บข้อมูลที่เข้าโมเดลแล้ว
  late GetGroupManagerModelAdmin dataGroup;
  late Future<List<MemberNotManagerGroup>> futureNotManagerGroup;
  late Future<GetGroupManagerModelAdmin> futureManagerGroup;
  late TooltipBehavior _tooltipBehavior;
  late SelectionBehavior _selectionBehavior;

  String choiceChipsValue = "พยาบาล";

  // List<List<String>> textlsit = [
  //   [
  //     "หัวหน้าพยาบาล",
  //     "พยาบาล",
  //     "พยาบาล",
  //     "พยาบาล",
  //     "พยาบาล",
  //   ],
  //   [
  //     "หัวหน้าพยาบาล",
  //     "พยาบาล",
  //     "พยาบาล",
  //     "หัวหน้าพยาบาล",
  //     "พยาบาล",
  //   ],
  //   [
  //     "หัวหน้าพยาบาล",
  //     "พยาบาล",
  //     "พยาบาล",
  //     "พยาบาล",
  //     "หัวหน้าพยาบาล",
  //   ],
  //   [
  //     "หัวหน้าพยาบาล",
  //     "พยาบาล",
  //     "หัวหน้าพยาบาล",
  //     "หัวหน้าพยาบาล",
  //     "พยาบาล",
  //   ],
  //   [
  //     "หัวหน้าพยาบาล",
  //     "พยาบาล",
  //     "พยาบาล",
  //     "หัวหน้าพยาบาล",
  //     "หัวหน้าพยาบาล",
  //   ]
  // ];
  List<String> actorNotMangerGroup = [];
  late List<List<String>> textlsit1;

  // แสดงข้อมูลที่จัดกลุ่มแล้ว
  Future<GetGroupManagerModelAdmin> getGroupManagerModel(
      {required String token}) async {
    try {
      print(token);
      final res = await http.get(
        Uri.parse("$url/api/admin/group"),
        headers: {
          "Accept": "application/json",
          "Access-Control_Allow_Origin": "*",
          "x-access-token": "$token"
        },
      );
      print("getGroupManagerModel state ${res.statusCode}");
      print("getGroupManagerModel body ${res.body}");
      setState(() {
        dataGroup = getGroupManagerModelAdminFromJson(res.body);
      });
      // final _futureManagerGroup =
      //     GetGroupManagerModelAdmin.fromJson(body as Map<String, dynamic>);
      final futureManagerGroup = dataGroup as GetGroupManagerModelAdmin;
      if (res.statusCode == 200) {
        for (int i = 0; i < futureManagerGroup.group!.length; i++) {
          textlsit1.add([]);
          for (int a = 0;
              a < futureManagerGroup.group![i].member!.length;
              a++) {
            textlsit1[i]
                .add(futureManagerGroup.group![i].member![a].actor as String);
          }
        }
        await notifica(context, "แสดงข้อมูลจัดกลุ่มเสำเร็จ",
            color: Colors.green);

        return futureManagerGroup;
      } else {
        await notifica(
          context,
          "แสดงข้อมูลไม่สำเร็จ",
        );
      }
      return futureManagerGroup;
    } catch (error) {
      print(error);
    }
    return GetGroupManagerModelAdmin();
  }

// ใช้สำหรับทดสอบเท่านั้น
  late Future<String> testString;
  Future<String> gettest({required String token}) async {
    try {
      print(token);
      final res = await http.get(
        Uri.parse("$url/api/admin/group"),
        headers: {
          "Accept": "application/json",
          "Access-Control_Allow_Origin": "*",
          "x-access-token": "$token"
        },
      );
      print("getGroupManagerModel state ${res.statusCode}");
      print("getGroupManagerModel body ${res.body}");
      setState(() {
        dataGroup = getGroupManagerModelAdminFromJson(res.body);
      });
      // final _futureManagerGroup =
      //     GetGroupManagerModelAdmin.fromJson(body as Map<String, dynamic>);
      final futureManagerGroup = dataGroup as GetGroupManagerModelAdmin;
      if (res.statusCode == 200) {
        for (int i = 0; i < futureManagerGroup.group!.length; i++) {
          textlsit1.add([]);
          for (int a = 0;
              a < futureManagerGroup.group![i].member!.length;
              a++) {
            textlsit1[i]
                .add(futureManagerGroup.group![i].member![a].actor as String);
          }
        }
        await notifica(context, "แสดงข้อมูลจัดกลุ่มเสำเร็จ",
            color: Colors.green);

        return "complete";
      } else {
        await notifica(
          context,
          "แสดงข้อมูลไม่สำเร็จ",
        );
      }
      return "not complete";
    } catch (error) {
      print(error);
    }
    return "Noll string";
  }

  @override
  void initState() {
    super.initState();
    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {});
    // FFAppState().tokenStore =
    //     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjp7InN1YiI6IjYyY2JjNGU1NDIwYzllMWFmZjJkN2I4MCIsInYiOjE1fSwiaWF0IjoxNjYyNTQzMTk2LCJleHAiOjE2NjMxNDc5OTZ9.lT_pPstFB5YKUZdpMgeCAWFr46JFfaLmcpqPm37-sEA";

    // print(dataGroup.data!.first.group);
    textlsit1 = [];

    futureManagerGroup = getGroupManagerModel(token: FFAppState().tokenStore);
    print("textlsit1 ${textlsit1}");
    _tooltipBehavior =
        TooltipBehavior(enable: true, header: "", canShowMarker: false);
    _selectionBehavior = SelectionBehavior(enable: true);
    testString = gettest(token: FFAppState().tokenStore);
  }

  // List<List<String>> _generateData() {
  //   // int numberOfGroups = 5;
  //   List<List<String>> results = <List<String>>[];
  //   for (int i = 0; i < textlsit1.length; i++) {
  //     List<String> items = <String>[];
  //     for (int j = 0; j < textlsit1[i].length; j++) {
  //       items.add(
  //           "${dataGroup.group![i].member![j].fristName} ${dataGroup.group![i].member![j].lastName} ${i} ${j} ${dataGroup.group![i].member![j].id}");
  //     }
  //     results.add(items);
  //   }
  //   return results;
  // }
  @override
  void dispose() {
    // TODO: implement dispose
    textlsit1.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // FFAppState().itemsduty = "";
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
      key: scaffoldKey,
      // floatingActionButton: Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   children: [
      //     SizedBox(
      //       width: 200.0,
      //       height: 40.0,
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.fromLTRB(0, 0, 0, 80),
      //       child: FloatingActionButton.extended(
      //         heroTag: "CreateGroup",
      //         onPressed: () {
      //           print('สร้างกลุ่ม');
      //         },
      //         backgroundColor: FlutterFlowTheme.of(context).primaryBlue,
      //         icon: const Icon(
      //           Icons.add,
      //           size: 35,
      //         ),
      //         elevation: 10,
      //         label: Padding(
      //           padding: const EdgeInsets.all(8.0),
      //           child: Text(
      //             "สร้างกลุ่ม",
      //             style: GoogleFonts.mitr(fontSize: 24, color: Colors.white),
      //           ),
      //         ),
      //       ),
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.fromLTRB(0, 0, 0, 80),
      //       child: FloatingActionButton.extended(
      //         heroTag: "Logout",
      //         onPressed: () async {
      //           logoutCallOutput = await LogoutCall.call(
      //             token: FFAppState().tokenStore,
      //           );
      //           // setState(() => FFAppState().tokenStore = '');
      //           if (((logoutCallOutput?.statusCode ?? 200)) == 200) {
      //             setState(() => FFAppState().tokenStore = '');
      //             await actions.notifica(
      //               context,
      //               'ออกจากระบบแล้ว',
      //             );
      //             Navigator.pushReplacement(
      //                 context,
      //                 MaterialPageRoute(
      //                   builder: (context) => FirstscreenWidget(),
      //                 ));
      //           } else {
      //             setState(() => FFAppState().tokenStore = '');
      //             await actions.notifica(
      //               context,
      //               'ออกจากระบบไม่สำเร็จ',
      //             );
      //           }
      //         },
      //         backgroundColor: FlutterFlowTheme.of(context).primaryRed,
      //         elevation: 10,
      //         label: Text(
      //           "ออกจากระบบ",
      //           style: GoogleFonts.mitr(fontSize: 24, color: Colors.white),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryWhite,
        automaticallyImplyLeading: false,
        actions: [
          Align(
            alignment: AlignmentDirectional(0, 0),
            child: Text(
              'Jonh Liam',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).title2.override(
                    fontFamily: FlutterFlowTheme.of(context).title2Family,
                    fontSize: 24,
                  ),
            ),
          ),
          const CustomButtonTest(),
          // TextButton(
          //     onPressed: () {
          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) => CustomButtonTest()));
          //     },
          //     child: Text("aaa")),
        ],
        centerTitle: false,
        elevation: 2,
      ),
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
          child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                      loadMoreIndicatorBuilder: (BuildContext context,
                          ChartSwipeDirection direction) {
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
              padding: const EdgeInsets.fromLTRB(50,10,0,0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10,0,0,0),
                    child: Row(
                      children: [
                        Container(
                          width: 25.0,
                          height: 25.0,
                          color: Color(0xFFF56CCF2),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10,0,0,0),
                          child: Text("ชั่วโมงการทำงาน",style: GoogleFonts.mitr(
                                  fontSize: 24, color: Color(0xFFF727272)),
                            ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10,0,0,0),
                    child: Row(
                      children: [
                        Container(
                          width: 25.0,
                          height: 25.0,
                          color: Color(0xFFF9B51E0),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10,0,0,0),
                          child: Text("ค่าเฉลีย",style: GoogleFonts.mitr(
                                  fontSize: 24, color: Color(0xFFF727272)),
                            ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10,0,0,0),
                    child: Row(
                      children: [
                        Container(
                          width: 25.0,
                          height: 25.0,
                          color: Color(0xFFF1033FD),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10,0,0,0),
                          child: Text("มัธยฐาน",style: GoogleFonts.mitr(
                                  fontSize: 24, color: Color(0xFFF727272)),
                            ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10,0,0,0),
                    child: Row(
                      children: [
                        Container(
                          width: 25.0,
                          height: 25.0,
                          color: Color(0xFFF2C94C),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10,0,0,0),
                          child: Text("ฐานนิยม",style: GoogleFonts.mitr(
                                  fontSize: 24, color: Color(0xFFF727272)),
                            ),
                        ),
                      ],
                    ),
                  ),
                  
                ],
              ),
            ),

            // ExpandableTheme(
            //   data: const ExpandableThemeData(
            //       iconPadding: EdgeInsets.fromLTRB(0, 15, 8, 8),
            //       animationDuration: Duration(milliseconds: 250)),
            //   child: ExpandablePanel(
            //     header: Row(
            //       mainAxisSize: MainAxisSize.max,
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Padding(
            //           padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
            //           child: Text(
            //             "จัดกลุ่มแล้ว",
            //             style: GoogleFonts.mitr(
            //                 fontSize: 24, color: Color(0xFFF727272)),
            //           ),
            //         ),
            //         Padding(
            //           padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            //           child: TextButton(
            //             onPressed: () {
            //               setState(() {
            //                 stataShowManagerGroup = !stataShowManagerGroup;
            //               });
            //               print("$stataShowManagerGroup");
            //             },
            //             child: Text(
            //               stataShowManagerGroup ? "ซ่อน" : "แสดงทั้งหมด",
            //               style: GoogleFonts.mitr(
            //                 fontSize: 24,
            //                 color: FlutterFlowTheme.of(context).primaryBlue,
            //               ),
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //     collapsed: FutureBuilder<GetGroupManagerModelAdmin>(
            //         future: futureManagerGroup,
            //         builder: ((context, dataManagerGroup) {
            //           if (!dataManagerGroup.hasData) {
            //             return Center(
            //               child: SizedBox(
            //                 width: 50,
            //                 height: 50,
            //                 child: CircularProgressIndicator(
            //                   color: FlutterFlowTheme.of(context).primaryColor,
            //                 ),
            //               ),
            //             );
            //           }
            //           if (dataManagerGroup == null) {
            //             return Center(
            //               child: SizedBox(
            //                   width: 50, height: 50, child: Text("ว่าง")),
            //             );
            //           }
            //           if (dataManagerGroup.hasError) {
            //             return Center(
            //               child: Text("เกิดข้อผิดพลาด"),
            //             );
            //           }

            //           GetGroupManagerModelAdmin listviewdataManagerGroup =
            //               dataManagerGroup.data!;
            //           if (listviewdataManagerGroup.group == null) {
            //             return Center(
            //               child: SizedBox(
            //                 width: 50,
            //                 height: 50,
            //                 child: CircularProgressIndicator(
            //                   color: FlutterFlowTheme.of(context).primaryColor,
            //                 ),
            //               ),
            //             );
            //           }
            //           return ListView.builder(
            //               physics: const NeverScrollableScrollPhysics(),
            //               shrinkWrap: true,
            //               itemCount: listviewdataManagerGroup.group!.length,
            //               itemBuilder: ((context, indexGroup) {
            //                 final indexnumber1 = indexGroup;
            //                 return ExpansionTile(
            //                     initiallyExpanded: stataShowManagerGroup,
            //                     title: const SizedBox(),
            //                     leading: Padding(
            //                       padding: const EdgeInsets.all(8.0),
            //                       child: Text(
            //                         "${indexnumber1 + 1} ${listviewdataManagerGroup.group![indexGroup].nameGroup}",
            //                         style: GoogleFonts.mitr(
            //                           fontSize: 20,
            //                           color: Color(0xFFF727272),
            //                         ),
            //                       ),
            //                     ),
            //                     children: [
            //                       ItemGroup(
            //                         listviewdataManagerGroup:
            //                             listviewdataManagerGroup,
            //                         stataShowManagerGroup:
            //                             stataShowManagerGroup,
            //                         textlsit1: textlsit1,
            //                         indexGroup: indexGroup,
            //                       ),
            //                     ]);
            //               }));
            //         })),
            //     expanded: SizedBox(),
            //   ),
            // ),

            Container(
              height: 100.0,
              width: 100.0,
            )
          ],
        ),
      )),
    );
  }

  Widget getLoadMoreViewBuilder(
      BuildContext context, ChartSwipeDirection direction) {
    if (direction == ChartSwipeDirection.end) {
      return FutureBuilder<String>(
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
