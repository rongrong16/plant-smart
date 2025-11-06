import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class PlantIDService {
  final String apiKey;

  PlantIDService(this.apiKey);

  Future<Map<String, dynamic>?> identifyHealth(String imagePath) async {
    try {
      var uri = Uri.parse('https://plant.id/api/v3/health_assessment?details=local_name,description,url,treatment,classification,common_names,cause');
      var request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('images', imagePath));

      request.headers['Api-Key'] = apiKey;

      var response = await request.send();


      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        var decodedResponse = jsonDecode(responseString);
        print('Response: $decodedResponse');
        if (decodedResponse['result'] != null) {
          var result = decodedResponse['result'];
          var isHealthyData = result['is_healthy'];
          if (isHealthyData != null && isHealthyData['binary'] == true) {
            var isHealthy = isHealthyData['binary'];
            if (isHealthy) {
              var healthDetails = {
                'is_healthy': true,
                'local_name': 'Healthy',
                'description': 'No disease or health issues detected.',
                'treatment': 'No treatment needed.',
              };
              return healthDetails;
            }
          }

          if (result.containsKey('disease') && result['disease'] != null && result['disease'].containsKey('suggestions')) {
            var suggestions = result['disease']['suggestions'];
            if (suggestions.isNotEmpty) {
              var diseaseDetails = {
                'is_healthy': false,
                'local_name': suggestions[0]['details']['local_name'],
                'description': suggestions[0]['details']['description'],
                'treatment': suggestions[0]['details']['treatment'],
              };
              return diseaseDetails;
            }
          }

          if (result.containsKey('health') && result['health'] != null && result['health'].containsKey('suggestions')) {
            var suggestions = result['health']['suggestions'];
            if (suggestions.isNotEmpty) {
              var healthDetails = {
                'is_healthy': false,
                'local_name': 'Health Issue',
                'description': suggestions[0]['details']['description'],
                'treatment': suggestions[0]['details']['treatment'] ?? 'No specific treatment suggested.',
              };
              return healthDetails;
            }
          }
        }
      } else {
        print('Error: Status code ${response.statusCode}');
      }
    } catch (e) {
      print('Error making API call: $e');
    }
    return null;
  }
}
