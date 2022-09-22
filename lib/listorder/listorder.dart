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
import '../model/profile_model.dart';
import 'creategroup_widget.dart';
import 'details.dart';
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
  late Future<Data> futureProfile;

  List<String> grouplist = [];

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

  Future<Data> getProfile({required String token}) async {
    try {
      final res = await http.get(
        Uri.parse("$url/api/me/profile"),
        headers: {
          'content-type': 'application/json',
          'Access-Control_Allow_Origin': '*',
          "x-access-token": "$token"
        },
      );
      final _futureProfile1 = getProfileFromJson(res.body);
      final futureProfile = _futureProfile1.data as Data;
      FFAppState().id = "${futureProfile.id}";
      FFAppState().firstname = "${futureProfile.fristName}";
      FFAppState().lastname = "${futureProfile.lastName}";
      FFAppState().actor = "${futureProfile.actor}";
      if (res.statusCode == 200) {
        await notifica(context, "แสดงข้อมูลโปรไฟล์สำเร็จ", color: Colors.green);
        return futureProfile;
      } else {
        await notifica(context, "แสดงข้อมูลโปรไฟล์ไม่สำเร็จ");
        await Future.delayed(Duration(seconds: 5));
        setState(() {});
      }
    } catch (error) {
      await notifica(context, "เกิดข้อผิดพลาด");
      await Future.delayed(Duration(seconds: 5));
      setState(() {});
    }
    return Data();
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
          grouplist.add("${futureManagerGroup.group![i].nameGroup}");
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
    // ใช่สำหรับทดสอบ
    testString = gettest(token: FFAppState().tokenStore);
    futureProfile = getProfile(token: FFAppState().tokenStore);
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
          FutureBuilder<Data>(
              future: futureProfile,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 40,
                      height: 5,
                      child: CircularProgressIndicator(
                        color: FlutterFlowTheme.of(context).primaryColor,
                      ),
                    ),
                  );
                }
                final profileData = snapshot.data!;
                return Row(
                  children: [
                    Align(
                      alignment: AlignmentDirectional(0, 0),
                      child: Text(
                        '${profileData.fristName} ${profileData.lastName}',
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).title2.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).title2Family,
                              fontSize: 24,
                            ),
                      ),
                    ),
                    const CustomButtonTest(),
                  ],
                );
              }),

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
            // จัดกลุ่มแล้ว
            ExpandableTheme(
              data: const ExpandableThemeData(
                  iconPadding: EdgeInsets.fromLTRB(0, 15, 8, 8),
                  animationDuration: Duration(milliseconds: 250)),
              child: ExpandablePanel(
                header: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
                      child: Text(
                        "กลุ่ม",
                        style: GoogleFonts.mitr(
                            fontSize: 24, color: Color(0xFFF727272)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            stataShowManagerGroup = !stataShowManagerGroup;
                          });
                          print("$stataShowManagerGroup");
                        },
                        child: Text(
                          stataShowManagerGroup ? "ซ่อน" : "แสดงทั้งหมด",
                          style: GoogleFonts.mitr(
                            fontSize: 24,
                            color: FlutterFlowTheme.of(context).primaryBlue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                collapsed: FutureBuilder<GetGroupManagerModelAdmin>(
                    future: futureManagerGroup,
                    builder: ((context, dataManagerGroup) {
                      if (!dataManagerGroup.hasData) {
                        return Center(
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(
                              color: FlutterFlowTheme.of(context).primaryColor,
                            ),
                          ),
                        );
                      }
                      if (dataManagerGroup == null) {
                        return Center(
                          child: SizedBox(
                              width: 50, height: 50, child: Text("ว่าง")),
                        );
                      }
                      if (dataManagerGroup.hasError) {
                        return Center(
                          child: Text("เกิดข้อผิดพลาด"),
                        );
                      }

                      GetGroupManagerModelAdmin listviewdataManagerGroup =
                          dataManagerGroup.data!;
                      if (listviewdataManagerGroup.group == null) {
                        return Center(
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(
                              color: FlutterFlowTheme.of(context).primaryColor,
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: listviewdataManagerGroup.group!.length,
                          itemBuilder: ((context, indexGroup) {
                            final indexnumber1 = indexGroup;
                            return ExpansionTile(
                                initiallyExpanded: stataShowManagerGroup,
                                title: const SizedBox(),
                                leading: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "${indexnumber1 + 1} ${listviewdataManagerGroup.group![indexGroup].nameGroup}",
                                    style: GoogleFonts.mitr(
                                      fontSize: 20,
                                      color: Color(0xFFF727272),
                                    ),
                                  ),
                                ),
                                children: [
                                  ItemGroup(
                                    listviewdataManagerGroup:
                                        listviewdataManagerGroup,
                                    stataShowManagerGroup:
                                        stataShowManagerGroup,
                                    textlsit1: textlsit1,
                                    indexGroup: indexGroup,
                                    grouplist: grouplist,
                                  ),
                                ]);
                          }));
                    })),
                expanded: SizedBox(),
              ),
            ),
            Container(
              height: 100.0,
              width: 100.0,
            )
          ],
        ),
      )),
    );
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

class ItemGroup extends StatefulWidget {
  GetGroupManagerModelAdmin listviewdataManagerGroup;
  bool stataShowManagerGroup;
  List<List<String>> textlsit1;
  int indexGroup;
  List<String> grouplist;
  ItemGroup(
      {super.key,
      required this.listviewdataManagerGroup,
      required this.stataShowManagerGroup,
      required this.textlsit1,
      required this.indexGroup,
      required this.grouplist});

  @override
  State<ItemGroup> createState() => _ItemGroupState();
}

class _ItemGroupState extends State<ItemGroup> {
  // แก้ไข actor
  updateMyUserActor({
    required String idUser,
    required String actor,
  }) async {
    try {
      final res = await http.patch(
        Uri.parse("$url/api/admin/updateUser/$idUser"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Access-Control_Allow_Origin': '*',
          'x-access-token': '${FFAppState().tokenStore}',
        },
        body: convert.json.encode({"actor": "${actor}"}),
      );
      // await Future.delayed(Duration(seconds: 3));
      // print("getGroupManagerModel body ${res.body}");
      print("getGroupManagerModel state ${res.statusCode}");

      if (res.statusCode == 200) {
        await notifica(context, "แก้ไขบทบาทสำเร็จ", color: Colors.green);
      } else {
        await notifica(
          context,
          "แก้ไขบทบาทไม่สำเร็จ",
        );
        return res;
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget
            .listviewdataManagerGroup.group![widget.indexGroup].member!.length,
        itemBuilder: (context, indexName) {
          return ListTile(
            onTap: () {},
            title: Padding(
              padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "${widget.listviewdataManagerGroup.group![widget.indexGroup].member![indexName].fristName} ${widget.listviewdataManagerGroup.group![widget.indexGroup].member![indexName].lastName}",
                    style: GoogleFonts.mitr(
                      fontSize: 20,
                      color: Color(0xFFF727272),
                    ),
                  ),
                  Text(
                    "${widget.listviewdataManagerGroup.group![widget.indexGroup].member![indexName].actor}",
                    style: GoogleFonts.mitr(
                      fontSize: 20,
                      color: Color(0xFFF727272),
                    ),
                  ),
                  Text(
                    "48",
                    style: GoogleFonts.mitr(
                      fontSize: 20,
                      color: Color(0xFFF727272),
                    ),
                  ),
                  Text(
                    "42",
                    style: GoogleFonts.mitr(
                      fontSize: 20,
                      color: Color(0xFFF727272),
                    ),
                  ),
                  Text(
                    "50",
                    style: GoogleFonts.mitr(
                      fontSize: 20,
                      color: Color(0xFFF727272),
                    ),
                  ),
                  Text(
                    "48",
                    style: GoogleFonts.mitr(
                      fontSize: 20,
                      color: Color(0xFFF727272),
                    ),
                  ),
                  SizedBox(
                    width: 181.0,
                    height: 45,
                    child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Details()));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                FlutterFlowTheme.of(context).primaryBlue,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide.none,
                            )),
                        icon: Icon(Icons.arrow_circle_right_outlined),
                        label: Text(
                          "รายละเอียด",
                          style: GoogleFonts.mitr(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        )),
                  ),
                ],
              ),
            ),
          );
        });
    // subtitle: SizedBox(child: Text("tttttttt"),)
  }
}
