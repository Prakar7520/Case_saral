import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:ver2/Components/SplashScreen.dart';
import 'package:ver2/Models/MyCaseList.dart';
import 'package:ver2/Models/UserModel.dart';

import '../Config.dart';

class CaseProvider with ChangeNotifier{

  MyCaseList caseList;
  String errormsg;
  List<MyCaseList> casesAll;
  List<MyCaseList> casesFinalAll;
  List<UserModel> user;
  String firstname;

  Future<List<MyCaseList>> fetchCase() async {

    var url = Config.apiUrl;
    var response = await http.get(url);
    List<MyCaseList> cases = [];

    if(response.statusCode == 200){

      for(var note in jsonDecode(response.body)){
        cases.add(MyCaseList.fromJson(note));
      }
    }
    else{
      throw Exception("Failed to Load");
    }
    return cases;

  }

  Future<List<UserModel>> fetchUser() async {
    var url = Config.userUrl;
    var response = await http.get(url);
    List<UserModel> users = [];

    if (response.statusCode == 200) {
      for (var note in jsonDecode(response.body)) {
        users.add(UserModel.fromJson(note));
      }
    }
    else {
      print("Failed");
      throw Exception("Failed to Load");
    }
    return users;
  }

  void setUser()async{
    await fetchUser().then((value) => user = value);
  }

  String loggedInUsername(){
    if(user == null){
      firstname = userLoggedIn;
    }
    else{
      user.map((value) {
        if(userLoggedIn == value.username){
          firstname = value.firstname;
        }
      }).toList();
    }

    return firstname;
  }

  List<UserModel> getUser(){
    return user;
  }

  void setCase()async {
    print("refreshed");
    await fetchCase().then((value) => casesAll = value);
  }

  List<MyCaseList> getCase(){
    // List<MyCaseList> caseFin = [];
    // casesAll.map((e) {
    //   if( e.valid == 1){
    //     caseFin.add(e);
    //   }
    // }).toList();
    // return caseFin;
    return casesAll;
  }

  List<MyCaseList> getTodayCase(){
    List<MyCaseList> todayCase = [];
    casesAll.map((item) {
      if(item.hearing_date == DateFormat('dd/MM/yyyy').format(DateTime.now())){
        todayCase.add(item);
      }

    }).toList();
    return todayCase;
  }

  List<MyCaseList> getCaseDate(String date){

    List<MyCaseList> caseListToday;
    List<MyCaseList> casesAll = getCase();

    casesAll.map((value) {

      if(value.hearing_date == date){
        caseListToday.add(value);
      }

    }).toList();

    return caseListToday;

  }
}