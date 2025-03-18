import 'dart:convert';

import 'package:organ/setting/server.dart';
import 'package:http/http.dart' as http;

class ControllerCustom {
  //api 경로
  String? apiUrl;
  //root 경로
  String rootRoute = '/api';

  String role = 'user';
  // 모델명
  String? modelName;
  // 모델 id
  String? modelId;

  // 결합된 경로 (ex: http://localhost:3000/api/user)
  String? mergedPath;

  ControllerCustom({this.modelName, this.modelId}) {
    apiUrl = serverSettings.config!['apiUrl']; // config에서 apiUrl에 접근합니다.
    mergedPath =
        '$apiUrl$rootRoute/$role/$modelId'; // apiUrl과 modelName을 결합합니다.
    modelName = modelName;
  }

  //로컬 로그인 option: {USER_NAME: ''}
  Future<Map<String, dynamic>> signIn(Map option) async {
    Uri url = Uri.http('$apiUrl', '$rootRoute/$role/$modelId/sign_in/local');
    // Uri url = Uri.http(
    //   '10.0.2.2:4021',
    //   '$rootRoute/$role/$modelId/sign_in/local',
    // );

    final response = await http.post(url, body: option);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseMap = json.decode(response.body);
      return responseMap;
    }
    throw Exception('Failed to load data');
  }
}
