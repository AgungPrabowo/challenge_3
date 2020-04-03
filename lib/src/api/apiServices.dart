import 'dart:convert';
import 'package:challenge_3/src/model/modelCountries.dart';
import 'package:challenge_3/src/model/modelNews.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  final client = http.Client();

  Future<List<ModelCountries>> coronaCountries() async {
    try {
      final response = await client
          .get('https://coronavirus-tracker-api.herokuapp.com/v2/locations');
      final result = json.decode(response.body);
      List<ModelCountries> dataCorona = (result["locations"] as List)
          .map((data) => ModelCountries.fromJson(data))
          .toList();
      return dataCorona;
    } catch (e) {
      print(e);
    }
  }

  Future<ModelNews> coronaNews({String location: "US"}) async {
    final String url =
        "https://api.smartable.ai/coronavirus/news/${location.toUpperCase()}";
    final Map<String, String> headers = {
      "Subscription-Key": "3009d4ccc29e4808af1ccc25c69b4d5d"
    };
    try {
      final response = await client.get(url, headers: headers);
      final result = json.decode(response.body);
      ModelNews dataNews = ModelNews.fromJson(result);
      return dataNews;
    } catch (e) {
      print(e);
    }
  }
}
