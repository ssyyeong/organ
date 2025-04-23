import 'dart:convert';

import 'package:organ/setting/server.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Controller {
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

  // 모델 설정
  Map? modelConfig;

  Controller({this.modelName, this.modelId}) {
    apiUrl = serverSettings.config!['apiUrl']; // config에서 apiUrl에 접근합니다.
    mergedPath =
        '$apiUrl$rootRoute/$role/$modelId'; // apiUrl과 modelName을 결합합니다.
    modelName = modelName;
  }

  parseResponse(Response response) {
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseMap = json.decode(response.body);
      // 받은 데이터를 JSON으로 디코딩 한다.
      return responseMap;
    }
    throw Exception('Failed to load data');
  }

  Future<Map<String, dynamic>> getModelConfig() async {
    Uri url = Uri.http('$apiUrl', '$rootRoute/common/model/find_one', {
      'MODEL_NAME': modelName,
    });
    // Uri url = Uri.http('10.0.2.2:4021', '$rootRoute/common/model/find_one', {
    //   'MODEL_NAME': modelName,
    // });

    final response = await http.get(url);
    Map<String, dynamic> res = parseResponse(response);
    return res.containsKey('result') ? res['result'] : null;
  }

  Future<Map<String, dynamic>> findOne(Map option) async {
    modelConfig ??= await getModelConfig();
    var findOption = {};

    if (modelConfig != null) {
      for (Map config in modelConfig!["FIND_ONE"]["FIND_OPTION_KEY_LIST"]) {
        findOption[config["KEY"]] = option[config["KEY"]];
      }
    }

    var wrappedFindOption = {"FIND_OPTION_KEY_LIST": jsonEncode(findOption)};

    Uri url = Uri.http(
      '$apiUrl',
      '$rootRoute/$role/$modelId/find_one',
      wrappedFindOption,
    );

    // Uri url = Uri.http(
    //   '10.0.2.2:4021',
    //   '$rootRoute/$role/$modelId/find_one',
    //   wrappedFindOption,
    // );

    final response = await http.get(url);

    // final response = await http.get(Uri.http('$mergedPath/find_one'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseMap = json.decode(response.body);
      return responseMap;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> findOneByKey(Map option) async {
    modelConfig ??= await getModelConfig();
    var wrappedFindOption = {"FIND_OPTION_KEY_LIST": jsonEncode(option)};

    Uri url = Uri.http(
      '$apiUrl',
      '$rootRoute/$role/$modelId/find_by_key',
      wrappedFindOption,
    );

    // Uri url = Uri.http('10.0.2.2:4021', '$rootRoute/$role/$modelId/find_by_key',
    //     wrappedFindOption);

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseMap = json.decode(response.body);
      return responseMap;
    }
    throw Exception('Failed to load data');
  }

  Future<Map<String, dynamic>> findAll(Map option) async {
    modelConfig ??= await getModelConfig();

    var findOption = {};

    for (Map config in modelConfig!["FIND_ALL"]["FIND_OPTION_KEY_LIST"]) {
      if (option[config["KEY"]] != null) {
        findOption[config["KEY"]] = option[config["KEY"]];
      }
    }

    var wrappedFindOption = {"FIND_OPTION_KEY_LIST": jsonEncode(findOption)};

    // Uri url = Uri.http(
    //   '10.0.2.2:4021',
    //   '$rootRoute/$role/$modelId/find_all',
    //   wrappedFindOption,
    // );
    Uri url = Uri.http(
      '$apiUrl',
      '$rootRoute/$role/$modelId/find_all',
      wrappedFindOption,
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> responseMap = json.decode(response.body);
      return responseMap;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> findAllByJoinKey(Map option) async {
    modelConfig ??= await getModelConfig();

    var findOption = option;
    var wrappedFindOption = {"FIND_OPTION_KEY_LIST": jsonEncode(findOption)};

    Uri url = Uri.http(
      '$apiUrl',
      '$rootRoute/$role/$modelId/find_all_by_joined_key',
      wrappedFindOption,
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseMap = json.decode(response.body);
      return responseMap;
    }
    throw Exception('Failed to load data');
  }

  Future<Map<String, dynamic>> create(Map option) async {
    modelConfig ??= await getModelConfig();

    var createOption = {};

    for (Map config in modelConfig!["CREATE"]["CREATE_OPTION_KEY_LIST"]) {
      if (option[config["KEY"]] != null) {
        createOption[config["KEY"]] = option[config["KEY"]];
      }
    }

    var wrappedCreateOption = {
      "CREATE_OPTION_KEY_LIST": jsonEncode(createOption),
    };

    // Uri url = Uri.http('$apiUrl', '$rootRoute/$role/$modelId/create');
    Uri url = Uri.http('10.0.2.2:4021', '$rootRoute/$role/$modelId/create');

    final response = await http.post(url, body: wrappedCreateOption);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseMap = json.decode(response.body);
      return responseMap;
    }
    throw Exception('Failed to load data');
  }

  Future<Map<String, dynamic>> update(Map option) async {
    modelConfig ??= await getModelConfig();

    var findOption = {};

    for (Map config in modelConfig!["UPDATE"]["FIND_OPTION_KEY_LIST"]) {
      if (option[config["KEY"]] != null) {
        findOption[config["KEY"]] = option[config["KEY"]];
      }
      // findOption[config["KEY"]] = option[config["KEY"]];
    }

    var updateOption = {};

    for (Map config in modelConfig!["UPDATE"]["UPDATE_OPTION_KEY_LIST"]) {
      if (option[config["KEY"]] != null) {
        updateOption[config["KEY"]] = option[config["KEY"]];
      }
    }

    var wrappedOption = {
      "FIND_OPTION_KEY_LIST": jsonEncode(findOption),
      "UPDATE_OPTION_KEY_LIST": jsonEncode(updateOption),
    };

    Uri url = Uri.http('$apiUrl', '$rootRoute/$role/$modelId/update');
    // Uri url = Uri.http('10.0.2.2:4021', '$rootRoute/$role/$modelId/update');

    final response = await http.put(url, body: wrappedOption);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseMap = json.decode(response.body);
      return responseMap;
    }
    throw Exception('Failed to load data');
  }

  Future<Map<String, dynamic>> delete(Map option) async {
    modelConfig ??= await getModelConfig();

    var findOption = {};

    for (Map config in modelConfig!["DELETE"]["FIND_OPTION_KEY_LIST"]) {
      if (option[config["KEY"]] != null) {
        findOption[config["KEY"]] = option[config["KEY"]];
      }
    }

    var deleteOption = {};

    for (Map config in modelConfig!["DELETE"]["UPDATE_OPTION_KEY_LIST"]) {
      if (option[config["KEY"]] != null) {
        deleteOption[config["KEY"]] = option[config["KEY"]];
      }
    }

    var wrappedOption = {
      "FIND_OPTION_KEY_LIST": jsonEncode(findOption),
      "UPDATE_OPTION_KEY_LIST": jsonEncode(deleteOption),
    };

    Uri url = Uri.http('$apiUrl', '$rootRoute/$role/$modelId/delete');
    // Uri url = Uri.http('10.0.2.2:4021', '$rootRoute/$role/$modelId/delete');

    final response = await http.put(url, body: wrappedOption);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseMap = json.decode(response.body);
      return responseMap;
    }
    throw Exception('Failed to load data');
  }
}
