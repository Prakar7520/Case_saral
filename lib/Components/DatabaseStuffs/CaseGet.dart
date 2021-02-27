import 'package:http/http.dart' as http;

import '../Config.dart';

class CaseGet {

  var url = Config.apiUrl;

  Future<http.Response> fetchCasess() {
    return http.get(url);
  }
  
}