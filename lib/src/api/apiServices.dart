import 'dart:convert';
import 'package:challenge_3/src/model/modelConfirmed.dart';
import 'package:challenge_3/src/model/modelCountries.dart';
import 'package:challenge_3/src/model/modelDeaths.dart';
import 'package:challenge_3/src/model/modelNews.dart';
import 'package:challenge_3/src/model/modelSummary.dart';
import 'package:challenge_3/src/model/modelYoutube.dart';
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
      return List<ModelCountries>();
    }
  }

  Future<ModelNews> coronaNews(String location) async {
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
      return ModelNews();
    }
  }

  Future<List<ModelConfirmed>> coronaConfirmed(String location) async {
    try {
      final response = await client.get(
          "https://api.covid19api.com/dayone/country/${location.toUpperCase()}/status/confirmed");
      final result = json.decode(response.body);
      List<ModelConfirmed> dataConfirmed =
          (result as List).map((f) => ModelConfirmed.fromJson(f)).toList();
      return dataConfirmed;
    } catch (e) {
      print(e);
      return List<ModelConfirmed>();
    }
  }

  Future<List<ModelDeaths>> coronaDeaths(String location) async {
    try {
      final response = await client.get(
          "https://api.covid19api.com/dayone/country/${location.toUpperCase()}/status/deaths");
      final result = json.decode(response.body);
      List<ModelDeaths> dataDeaths =
          (result as List).map((f) => ModelDeaths.fromJson(f)).toList();
      return dataDeaths;
    } catch (e) {
      print(e);
      return List<ModelDeaths>();
    }
  }

  Future<ModelSummary> coronaSummary() async {
    try {
      final response = await client.get("https://api.covid19api.com/summary");
      final result = json.decode(response.body);
      ModelSummary dataSummary = ModelSummary.fromJson(result);
      return dataSummary;
    } catch (e) {
      print(e);
      return ModelSummary();
    }
  }

  Future<ModelYoutube> coronaYoutube(String count) async {
    try {
      final response = await client.get(
          "https://www.googleapis.com/youtube/v3/search?key=AIzaSyBOVlHFNYRuLIYy34GUHEamrxlMnmyIlNk&channelId=UC07-dOwgza1IguKA86jqxNA&part=snippet,id&order=date&maxResults=${count}");
      final result = json.decode(response.body);
      ModelYoutube dataYoutube = ModelYoutube.fromJson(result);
      return dataYoutube;
    } catch (e) {
      print(e);
      return ModelYoutube();
    }
  }
}
