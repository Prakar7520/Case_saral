import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:ver2/Components/DatabaseStuffs/Databasedar.dart';
import 'package:ver2/Models/DetailScreenArgument.dart';
import 'package:ver2/Models/MyCaseList.dart';
import 'package:ver2/Services/Storage.dart';
import '../Components/Config.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import 'package:open_file/open_file.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

// ignore: must_be_immutable
class DetailsScreen extends StatefulWidget {

  static String id = "DetailsPage";
  bool updated;

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final c1 = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final DetailScreenArgument args = ModalRoute.of(context).settings.arguments;


    final String _fileUrl = Config.downloadUrl+"/"+args.caseId.toString();
    final String _fileName = "downloadPdf.pdf";
    final Dio _dio = Dio();

    Map<String, dynamic> result = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
    };

    String progress = "-";

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

    Future<void> _onSelectNotification(String json) async {
      final obj = jsonDecode(json);

      if (obj['isSuccess']) {
        OpenFile.open(obj['filePath']);
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Error'),
            content: Text('${obj['error']}'),
          ),
        );
      }
    }

    Future<Directory> _getDownloadDirectory() async {
      if (Platform.isAndroid) {
        return await DownloadsPathProvider.downloadsDirectory;
      }

      return await getApplicationDocumentsDirectory();
    }

    Future<bool> _requestPermissions() async {
      var permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);

      if (permission != PermissionStatus.granted) {
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);
        permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
      }

      return permission == PermissionStatus.granted;
    }

    void _onReceiveProgress(int received, int total) {
      if (total != -1) {
        setState(() {
          progress = (received / total * 100).toStringAsFixed(0) + "%";
        });
      }
    }

    Future<void> showNotification(Map<String, dynamic> downloadStatus) async {

      final android = AndroidNotificationDetails(
        'channel id',
        'channel name',
        'channel description',
        priority: Priority.High,
        importance: Importance.Max,
      );
      final iOS = IOSNotificationDetails();
      final platform = NotificationDetails(android, iOS);
      final json = jsonEncode(downloadStatus);
      final isSuccess = downloadStatus['isSuccess'];

      await flutterLocalNotificationsPlugin.show(
          0, // notification id
          isSuccess ? 'Success' : 'Failure',
          isSuccess ? 'File has been downloaded successfully!' : 'There was an error while downloading the file.',
          platform,
          payload: json
      );
    }

    Future<void> _startDownload(String savePath) async {

      try {
        final response = await _dio.download(
          _fileUrl,
          savePath,
          onReceiveProgress: _onReceiveProgress,
        );
        if(response.statusCode == 200){
          flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
          final android = AndroidInitializationSettings('@mipmap/ic_launcher');
          final iOS = IOSInitializationSettings();
          final InitializationSettings initSettings = InitializationSettings(android, iOS);
          flutterLocalNotificationsPlugin.initialize(initSettings, onSelectNotification: _onSelectNotification,);

          result['isSuccess'] = response.statusCode == 200;
          result['filePath'] = savePath;
          await showNotification(result);
        }
      } catch (ex) {
        return _popupDialog(context);
      }
    }

    Future<bool> _download() async {


      final dir = await _getDownloadDirectory();
      final isPermissionStatusGranted = await _requestPermissions();

      if (isPermissionStatusGranted) {
        final savePath = path.join(dir.path, _fileName);
        await _startDownload(savePath);

      } else {
        // handle the scenario when user declines the permissions
      }
    }

    Future<MyCaseList> updateRemarks(String officerRmks) async{
      String x = args.serialNo.toString();//assign args.serial_no = x.toString here for testing i used 3
      var url=Config.apiUrl+"/"+x;
      final http.Response response = await http.patch(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'officer_rmks': officerRmks,
        }),
      );
      if (response.statusCode == 200) {
        // If the server did return a 200 UPDATED response,
        // then parse the JSON.
        setState(() {
          widget.updated = true;
        });
        return MyCaseList.fromJson(jsonDecode(response.body));
      } else {
        widget.updated = false;
        throw Exception('Failed to load album');
      }
    }

    String remarks;
    if(args.officerRmks == null && c1.text == ""){
      remarks = "No remarks added";
    }
    else{
      setState(() {
        remarks = c1.text == "" ? args.officerRmks : c1.text;
      });
    }

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                Image.asset("assets/govtofsikkim.png",height: 70,width:70,),
                Text("Govt. Of Sikkim"),
                SizedBox(height: 20,),

                Text("Case Number: ${args.caseId}", style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),),

                Text(progress),
                SizedBox(height: 30,),

                Container(
                  width: size.width *0.9,
                  child: Card(
                    elevation: 4,
                    child: DataTable(
                        headingRowHeight: 0,
                        columns: <DataColumn>[
                          DataColumn(label: Text("")),
                          DataColumn(label: Text(""))
                        ],
                        rows: <DataRow>[
                          DataRow(
                              cells: <DataCell>[
                                DataCell(Text("Date")),
                                DataCell(Text("${args.date}")),
                              ]
                          ),
                          DataRow(
                              cells: <DataCell>[
                                DataCell(Text("Petitioner")),
                                DataCell(Text("${args.petitioner}")),
                              ]
                          ),
                          DataRow(
                              cells: <DataCell>[
                                DataCell(Text("Respondent")),
                                DataCell(Text("${args.respondent}")),
                              ]
                          ),
                          DataRow(
                              cells: <DataCell>[
                                DataCell(Text("Type")),
                                DataCell(Text("${args.caseType}")),
                              ]
                          ),
                          DataRow(
                              cells: <DataCell>[
                                DataCell(Text("Assigned To")),
                                DataCell(Text("${args.assignTo}")),
                              ]
                          ),

                        ]
                    ),
                  ),
                ),

                Container(
                  width: size.width *0.9,
                  child: Card(
                    elevation: 4,
                    child: DataTable(
                        headingRowHeight: 0,
                        columns: <DataColumn>[
                          DataColumn(label: Text("")),
                          DataColumn(label: Text(""))
                        ],
                        rows: <DataRow>[
                          DataRow(
                              cells: <DataCell>[
                                DataCell(Text("Hearing Date")),
                                DataCell(Text("${args.hearingDate}")),
                              ]
                          ),
                          DataRow(
                              cells: <DataCell>[
                                DataCell(Text("Status")),
                                DataCell(args.action == 'Inprogress' ? Text("${args.action}",style: TextStyle(color: Colors.green),) :
                                          args.action == 'Pending' ? Text("${args.action}",style: TextStyle(color: Colors.yellow),) :
                                          Text("${args.action}",style: TextStyle(color: Colors.red),)
                                ),
                              ]
                          ),
                        ]
                    ),
                  ),
                ),

                // SizedBox(height: 18,),

                RemarksWidget(size: size, rmks: args.peshkarRmks, whoseRemark: "Peshkar\'s Remark",),

                RemarksWidget(size: size, rmks: remarks, whoseRemark: "Officer\'s Remark",),

                widget.updated == null ? Container() :
                widget.updated == true ? Text("Remarks after change : Updated",style: TextStyle(color: Colors.green),):
                Text("Remarks Un-edited",style: TextStyle(color: Colors.red,),),


                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    args.dmHere == false ? Container(
                      decoration: BoxDecoration(
                          color: Colors.cyan[200],
                          borderRadius: BorderRadius.circular(12)
                      ),
                      child: FlatButton.icon(
                        color: Colors.cyan[200],
                        onPressed: (){
                          showModalBottomSheet(
                              context: context, builder: (context) => Container(

                            color: Color(0xff757575),
                            child: SingleChildScrollView(
                              child: Container(
                                padding: EdgeInsets.only(top: 40, left: 20, right: 20),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomRight,
                                      end: Alignment.topLeft,
                                      colors: [Colors.blueAccent,Colors.blueGrey]
                                    ),
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20), topLeft: Radius.circular(20))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      "Add remarks",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(20)),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, top: 10, right: 15, bottom: 10),
                                        child: TextFormField(
                                          controller: c1,
                                          decoration: InputDecoration(border: InputBorder.none),
                                          autofocus: true,
                                          maxLines: 3,
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: FlatButton.icon(
                                          color: Colors.grey[200],
                                          onPressed: () {
                                            setState(() {
                                              Provider.of<CaseProvider>(context,listen: false).setCase();
                                              remarks = c1.text;
                                              updateRemarks(remarks);
                                            });
                                            Navigator.pop(context);
                                          },
                                          icon: Icon(Icons.done),
                                          label: Text("Submit")),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ));
                        },
                        icon: Icon(Icons.edit),
                        label: Text("Remarks"),
                      ),
                    ) : Container(
                      width: size.width * 0.5,
                    ),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.cyan[200],
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: FlatButton(
                        onPressed: _download,
                        child: Icon(Icons.download_sharp),
                      ),
                    ),

                  ],
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
  void _popupDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Failed to Downoad'),
            content: Text('PDF on this Case ID doesn\'t exist'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK')),

            ],
          );
        });
  }
}

class RemarksWidget extends StatelessWidget {
  const RemarksWidget({
    Key key,
    @required this.size,
    @required this.rmks, this.whoseRemark,
  }) : super(key: key);

  final Size size;
  final String rmks;
  final String whoseRemark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width *0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(29),
      ),
      child: Card(
          elevation: 4,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    whoseRemark,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    rmks,
                  )
                ],
              ),
            ),
          )
      ),
    );
  }
}
