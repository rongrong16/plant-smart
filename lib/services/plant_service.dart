import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart';

class PlantService {
  final String apiKey;

  PlantService(this.apiKey);


  Future<dynamic> identifyPlant(String imagePath) async {
    var uri = Uri.parse('https://my-api.plantnet.org/v2/identify/all?include-related-images=true&no-reject=true&lang=en&type=kt&api-key=$apiKey');
    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('images', imagePath));

    // Set the API key in the request headers
    request.headers['Authorization'] = 'Bearer $apiKey';

    try {
      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);

      print('Response status: ${response.statusCode}');
      print('Response body: $responseString');

      if (response.statusCode == 200) {
        return jsonDecode(responseString);
      } else {
        return null;
      }
    } catch (e) {
      print('Error making API call: $e');
      return null;
    }
  }

  Future<String> uploadImageToStorage(File imageFile) async {
    try {
      String fileName = 'plant_images/${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref().child(fileName);

      firebase_storage.UploadTask uploadTask = ref.putFile(imageFile);
      firebase_storage.TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      throw Exception('Failed to upload image');
    }
  }

  Future<void> uploadPlantDetails(String commonName, String scientificName, String imageUrl) async {
    try {
      await FirebaseFirestore.instance.collection('plants').add({
        'commonName': commonName,
        'scientificName': scientificName,
        'imageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('Plant details uploaded successfully');
    } catch (e) {
      print('Error uploading plant details: $e');
      throw Exception('Error uploading plant details');
    }
  }
}
