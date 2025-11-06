import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'loginscreen.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Uint8List? _image;
  final picker = ImagePicker();
  String _userName = "";
  String _phoneNumber = "";
  String _email = "";
  bool _imageSaved = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
    _fetchUserData();
  }

  Future<void> _loadImage() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    if (user != null) {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (snapshot.exists) {
        final String? avatarUrl = snapshot.data()?['avatarUrl'];
        if (avatarUrl != null) {
          final response = await http.get(Uri.parse(avatarUrl));
          if (response.statusCode == 200) {
            setState(() {
              _image = response.bodyBytes;
              _imageSaved = true;
            });
          } else {
            print('Failed to load image with status code: ${response.statusCode}');
          }
        }
      }
    }
  }

  Future<void> _saveImage(Uint8List image) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    if (user != null) {
      final Reference storageRef =
      FirebaseStorage.instance.ref().child('user_avatars').child('${user.uid}.jpg');
      final UploadTask uploadTask = storageRef.putData(image);
      await uploadTask.whenComplete(() async {
        final String url = await storageRef.getDownloadURL();
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({'avatarUrl': url});
        setState(() {
          _imageSaved = true;
        });
      });
    }
  }

  Future<void> _fetchUserData() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    if (user != null) {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (snapshot.exists) {
        setState(() {
          _userName = snapshot.data()?['username'] ?? "";
          _phoneNumber = snapshot.data()?['phoneNumber'] ?? "";
          _email = snapshot.data()?['email'] ?? "";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Color(0xFFF3F7EB),
        centerTitle: true, // Center the title
      ),
      backgroundColor: Color(0xFFF3F7EB),
      body: ListView(
        children: <Widget>[
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: getImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: _image != null ? MemoryImage(_image!) : null,
                    child: _image == null ? const Icon(Icons.camera_alt, size: 60, color: Colors.grey) : null,
                  ),
                ),
                const SizedBox(height: 45), // Increase spacing
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: ListTile(
                    leading: Icon(Icons.person, color: Colors.green),
                    title: Text(_userName, style: TextStyle(color: Colors.black)),
                  ),
                ),
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: ListTile(
                    leading: Icon(Icons.phone, color: Colors.green),
                    title: Text(_phoneNumber),
                  ),
                ),
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: ListTile(
                    leading: Icon(Icons.email, color: Colors.green),
                    title: Text(_email),
                  ),
                ),
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: ListTile(
                    leading: Icon(Icons.logout, color: Colors.green),
                    title: Text('Logout'),
                    onTap: _logout,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getImage() async {
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _image = bytes;
        _imageSaved = false;
      });
      await _saveImageToDatabase(_image!);
    } else {
      print('No image selected.');
    }
  }

  Future<void> _saveImageToDatabase(Uint8List image) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    if (user != null) {
      final Reference storageRef =
      FirebaseStorage.instance.ref().child('user_avatars').child('${user.uid}.jpg');
      final UploadTask uploadTask = storageRef.putData(image);
      await uploadTask.whenComplete(() async {
        final String url = await storageRef.getDownloadURL();
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({'avatarUrl': url});
        setState(() {
          _imageSaved = true;
        });
      });
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}
