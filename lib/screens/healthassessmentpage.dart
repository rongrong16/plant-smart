import 'dart:io';
import 'package:flutter/material.dart';
import '../services/plantId_service.dart';
import 'homepage.dart';

class HealthAssessmentResultPage extends StatelessWidget {
  final File imageFile;
  final String? plantName;

  const HealthAssessmentResultPage({
    Key? key,
    required this.imageFile,
    this.plantName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F7EB), // Light green background color
      appBar: AppBar(
        title: Text('Health Assessment Result'),
        backgroundColor: Color(0xFFF3F7EB),
        // Override the AppBar back button behavior.
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => _navigateBackToHealthAssessment(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding around the Column
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0), // Adding border radius
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Shadow color
                          spreadRadius: 3, // Spread radius
                          blurRadius: 5, // Blur radius
                          offset: Offset(0, 2), // Offset in the x and y direction
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0), // Adding border radius
                      child: Image.file(imageFile, fit: BoxFit.cover, width: 300, height: 300), // Adjust image size
                    ),
                  ),
                ),
                if (plantName != null)
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      children: [
                        TextSpan(
                          text: 'Plant Name: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: '$plantName',
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 20),
                FutureBuilder<Map<String, dynamic>?>(
                  future: _getHealthAssessment(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      var healthData = snapshot.data;
                      if (healthData != null) {
                        var isHealthy = healthData['is_healthy'];
                        if (isHealthy != null && isHealthy == true) {
                          return Text(
                            'No disease found',
                            style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          );
                        } else {
                          return Column(
                            children: [
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(color: Colors.black, fontSize: 20),
                                  children: [
                                    TextSpan(
                                      text: 'Health Assessment: ',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: '${healthData['local_name'] ?? 'Unknown'}',
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Description: ',
                                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      _cleanDescription(healthData['description']),
                                      style: TextStyle(color: Colors.black, fontSize: 16),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Treatment: ',
                                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      _cleanTreatment(healthData['treatment']),
                                      style: TextStyle(color: Colors.black, fontSize: 16),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                      } else {
                        return Text(
                          'No data available',
                          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        );
                      }
                    }
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green, // foreground
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  ),
                  child: Text('Back to Home'),
                  onPressed: () => _navigateBackToHomePage(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateBackToHomePage(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
          (Route<dynamic> route) => false,
    );
  }

  void _navigateBackToHealthAssessment(BuildContext context) {
    Navigator.pop(context);
  }

  Future<Map<String, dynamic>?> _getHealthAssessment() async {
    try {
      // Call the plant.id API for health assessment
      String apiKey = '4wvdWckkk8kkAYJbugWpJhffZhbytMFdXA21xUkVrpHrV5D2Za';
      var plantIDService = PlantIDService(apiKey);
      var healthAssessmentData = await plantIDService.identifyHealth(imageFile.path);

      // Check if the response contains valid data
      if (healthAssessmentData != null && healthAssessmentData.containsKey('error')) {
        // If the API returns an error, handle it appropriately
        throw Exception(healthAssessmentData['error']);
      }

      return healthAssessmentData;
    } catch (e) {
      // Handle any errors that occur during the API call
      print('Error fetching health assessment: $e');
      return null;
    }
  }


  String _cleanDescription(String? description) {
    return description?.replaceAll(RegExp(r'[{}[\]]'), '') ?? '';
  }

  String _cleanTreatment(dynamic treatment) {
    if (treatment is List) {
      return treatment.join(', ').replaceAll(RegExp(r'[{}[\]]'), '');
    } else {
      return treatment.toString().replaceAll(RegExp(r'[{}[\]]'), '');
    }
  }
}