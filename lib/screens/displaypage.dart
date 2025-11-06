import 'dart:io';
import 'package:flutter/material.dart';
import 'healthassessmentpage.dart';

class DisplayPage extends StatelessWidget {
  final File imageFile;
  final String? commonName;
  final String scientificName;
  final bool identifyHealth;

  const DisplayPage({
    Key? key,
    required this.imageFile,
    required this.scientificName,
    this.commonName,
    this.identifyHealth = false,
    required String imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _navigateBackToHomePage(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xFFF3F7EB), // Light green background color
        appBar: AppBar(
          title: Text('Identification Result'),
          backgroundColor: Color(0xFFF3F7EB),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => _navigateBackToHomePage(context),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5), // Shadow color
                          spreadRadius: 5, // Spread radius
                          blurRadius: 7, // Blur radius
                          offset: Offset(0, 3), // Offset in the x and y direction
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        imageFile,
                        fit: BoxFit.cover,
                        width: 300, // Set width as needed
                        height: 300, // Set height as needed
                      ),
                    ),
                  ),
                ),
                if (commonName != null)
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      children: [
                        TextSpan(
                          text: 'Common Name: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: commonName,
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Scientific Name: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: scientificName,
                      ),
                    ],
                  ),
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  child: Text(
                    'Back to Home',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  onPressed: () => _navigateBackToHomePage(context),
                ),
                SizedBox(height: 10),
                if (identifyHealth) SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  child: Text(
                    'Identify Health or Disease',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  onPressed: () => _navigateToHealthAssessment(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateBackToHomePage(BuildContext context) {
    Navigator.pop(context);
  }

  void _navigateToHealthAssessment(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HealthAssessmentResultPage(imageFile: imageFile, plantName: commonName),
      ),
    );
  }
}
