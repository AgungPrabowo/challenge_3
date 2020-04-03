import 'dart:convert';
import 'package:challenge_3/model/modelCountries.dart';
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
    } finally {
      client.close();
    }
  }
}
