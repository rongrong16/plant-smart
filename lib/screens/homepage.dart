import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantsmart/screens/plantdetails.dart';
import 'package:plantsmart/screens/profile.dart';
import '../services/plant_service.dart';
import 'displaypage.dart';
import 'gallery.dart';
import 'search.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final ImagePicker _picker = ImagePicker();
  bool _loading = false;
  String? _errorMessage;
  File? _image;
  String? _userName;
  String? _avatarUrl;
  final PlantService _plantService = PlantService('2b10jYA9pstrMMmJETbtJjyste');

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    // Fetch user data from Firestore using the user's UID
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      setState(() {
        _userName = userSnapshot.get('username');
        _avatarUrl = userSnapshot.get('avatarUrl');
      });
    }
  }

  Widget _getScreenAtIndex(int index) {
    switch (index) {
      case 0:
        return _buildHomeScreen();
      case 1:
        return Search();
      case 2:
        return Center();
      case 3:
        return GalleryPage();
      case 4:
        return const UserProfile();
      default:
        return Center(
          child: Text(
            'Screen $index',
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        );
    }
  }

  Future<void> _takePicture(ImageSource source) async {
    setState(() => _loading = true);
    final XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      setState(() => _image = File(image.path));
      File imageFile = File(image.path);

      try {
        // Upload the image to Firebase Storage and get the download URL
        String imageUrl = await _plantService.uploadImageToStorage(imageFile);
        // Identify the plant
        var result = await _plantService.identifyPlant(image.path);
        if (result != null && result['results'].isNotEmpty) {
          var commonName = result['results'][0]['species']['commonNames'].join(', ');
          var scientificName = result['results'][0]['species']['scientificName'];

          // Upload plant details to Firestore
          await _plantService.uploadPlantDetails(commonName, scientificName, imageUrl);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DisplayPage(
                imageFile: File(image.path),
                commonName: commonName,
                scientificName: scientificName,
                imageUrl: imageUrl,
              ),
            ),
          );
        } else {
          setState(() => _errorMessage = 'No result found');
        }
      } catch (e) {
        setState(() => _errorMessage = 'Error identifying plant. Please try again.');
      }
    } else {
      setState(() => _errorMessage = 'No image selected');
    }

    setState(() => _loading = false);
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      _showCameraOptions();
    } else {
      setState(() => _selectedIndex = index);
    }
  }

  void _showCameraOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Picture'),
                onTap: () {
                  Navigator.pop(context);
                  _takePicture(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Upload Picture'),
                onTap: () {
                  Navigator.pop(context);
                  _takePicture(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHomeScreen() {
    List<Map<String, dynamic>> plants = [
      {
        "name": "Aspidistra Elatior",
        "image": "assets/images/plant1.jpg",
        "description": "Aspidistra Elatior or the Cast Iron Plant belongs to the lily family and is native to China and Japan. It is known for its resilience and ability to tolerate low light conditions.",
        "careGuide": {
          "Sunlight": "Aspidistra Elatior thrives in low to moderate indirect light, making it ideal for shaded areas indoors. Avoid direct sunlight, as it can scorch the leaves.",
          "Watering": "Allow the soil to partially dry between waterings, ensuring it's not soggy. Water sparingly during winter, as the plant's growth slows down.",
          "Soil": "Use well-draining soil to prevent waterlogging and root rot.",
          "Care": "Keep the leaves clean by wiping them with a damp cloth to prevent dust buildup, which can hinder photosynthesis. Avoid overwatering to prevent root rot."
        },
        "moreImages": [
          "assets/images/1.2.jpg",
          "assets/images/1.3.jpg",
          "assets/images/1.4.jpg"
        ]
      },
      {
        "name": "Monstera",
        "image": "assets/images/plant2.jpg",
        "description": "Monstera, or Swiss cheese plant, features large glossy leaves with unique holes, adding tropical elegance to indoor spaces. It is a fast-growing plant that can thrive in various lighting conditions.",
        "careGuide": {
          "Sunlight": "Monstera prefers bright, indirect light but can tolerate some lower light conditions. Avoid direct sunlight.",
          "Watering": "Allow the top inch of soil to dry between waterings; check moisture by inserting your finger. Water less in winter.",
          "Soil": "Use well-draining soil with good aeration.",
          "Care": "Keep the leaves clean by wiping with a damp cloth to enhance photosynthesis. Prune dead or yellow leaves."
        },
        "moreImages": [
          "assets/images/2.2.jpg",
          "assets/images/2.3.jpg",
          "assets/images/2.4.jpg"
        ]
      },
      {
        "name": "Chinese Money Plant",
        "image": "assets/images/plant3.jpg",
        "description": "The Chinese Money Plant, also known as Pilea peperomioides, is a charming and popular houseplant characterized by its round, pancake-shaped leaves and unique architectural growth habit. Originating from southwestern China, this plant has gained popularity worldwide for its attractive appearance and easy care requirements. It is also known as the missionary plant.",
        "careGuide": {
          "Sunlight": "Chinese Money Plants prefer bright, indirect light. They can tolerate some lower light conditions but thrive best in a location with plenty of natural light. Avoid direct sunlight, as it can cause leaf burn.",
          "Watering": "Keep the soil evenly moist during the growing season (spring and summer), allowing the top inch of soil to dry out between waterings. Reduce watering frequency in the winter months, allowing the soil to dry out slightly more between waterings. Overwatering can lead to root rot, so it's essential to avoid waterlogged soil.",
          "Soil": "Use well-draining soil to prevent waterlogging and root rot.",
          "Care": "Regularly inspect the plant for signs of pests or disease. Prune yellow or dead leaves and stems. Rotate the plant occasionally to ensure even growth. Feed with a balanced fertilizer during the growing season."
        },
        "moreImages": [
          "assets/images/3.2.jpg",
          "assets/images/3.3.jpg",
          "assets/images/3.4.jpg"
        ]
      },
      {
        "name": "Strelitzia Nicolai",
        "image": "assets/images/plant4.jpg",
        "description": "Strelitzia Nicolai, also known as White Bird of Paradise, is a striking tropical plant with large, banana-like leaves and unique bird-shaped flowers. It originates from South Africa and thrives in warm, humid climates. It can grow up to 20 feet tall when grown outdoors.",
        "careGuide": {
          "Sunlight": "Place Strelitzia Nicolai in a bright location with indirect sunlight, avoiding intense afternoon sun. It thrives in partial shade to full sun conditions, making it adaptable to various indoor environments.",
          "Watering": "Water when the top inch of soil feels dry, usually every 1-2 weeks. Allow the soil to partially dry between waterings to prevent root rot. Ensure thorough watering, allowing excess water to drain freely from the pot.",
          "Soil": "Provide well-draining soil rich in organic matter. A mixture of peat moss, perlite, and coarse sand promotes healthy root growth.",
          "Care": "Temperature: Maintain indoor temperatures between 65-80°F (18-27°C) and avoid sudden temperature fluctuations."
        },
        "moreImages": [
          "assets/images/4.2.jpg",
          "assets/images/4.3.jpg",
          "assets/images/4.4.jpg"
        ]
      },
      {
        "name": "Prayer Plant",
        "image": "assets/images/plant5.jpg",
        "description": "Prayer Plant, also known as Maranta leuconeura, is a vibrant and eye-catching houseplant known for its decorative foliage that folds up at night, resembling praying hands. Originating from the rainforests of Brazil, this plant adds a touch of tropical beauty to indoor spaces. It is a member of the Marantaceae family, which includes other popular houseplants like Calathea and Stromanthe.",
        "careGuide": {
          "Sunlight": "Thrives in indirect to moderate light conditions. Avoid direct sunlight, as it can scorch the leaves. Can tolerate low light but may affect foliage coloration.",
          "Watering": "Keep the soil consistently moist during the growing season (spring and summer), allowing the top inch to dry out between waterings. Use room temperature water to avoid shocking the roots.",
          "Soil": "Use a well-draining, peat-based potting mix with added perlite or sand to improve drainage. Ensure the pot has drainage holes to prevent waterlogging.",
          "Care": "Temperature: Maintain indoor temperatures between 60-75°F (15-24°C) and protect from drafts or sudden temperature changes."
        },
        "moreImages": [
          "assets/images/5.2.jpg",
          "assets/images/5.3.jpg",
          "assets/images/5.4.jpg"
        ]
      }
    ];

    List<Map<String, dynamic>> popularPlants = [
      {
        "name": "ZZ Plant",
        "image": "assets/images/plant6.jpg",
        "description": "ZZ Plant, or Zamioculcas Zamiifolia, is a resilient and drought-tolerant plant with glossy green foliage, perfect for beginners. It is also known as the Zanzibar Gem.",
        "careGuide": {
          "Sunlight": "Thrives in low to moderate indirect light but can tolerate low light conditions. Avoid direct sunlight.",
          "Soil": "Prefers well-draining, sandy or loamy soil. Ensure adequate drainage to prevent waterlogging.",
          "Watering": "Allow the soil to dry out completely between waterings. Overwatering can cause root rot.",
          "Care": "Requires well-draining soil. Prune yellow or dead leaves and wipe the foliage occasionally to remove dust buildup."
        },
        "moreImages": [
          "assets/images/6.2.jpg",
          "assets/images/6.3.jpg",
          "assets/images/6.4.png"
        ]
      },
      {
        "name": "Peace Lily",
        "image": "assets/images/plant7.jpg",
        "description": "Peace Lily, or Spathiphyllum, is a popular indoor plant with elegant white flowers and lush green foliage, known for its air-purifying properties. It is native to tropical regions of the Americas.",
        "careGuide": {
          "Sunlight": "Prefers moderate indirect light but can tolerate low light conditions. Avoid direct sunlight.",
          "Watering": "Keep the soil consistently moist, but not soggy. Water when the top inch of soil feels dry.",
          "Soil:": "Requires well-draining soil.",
          "Pruning": "Prune faded flowers and wipe the foliage occasionally to remove dust buildup."
        },
        "moreImages": [
          "assets/images/7.2.jpg",
          "assets/images/7.3.jpg",
          "assets/images/7.4.jpg"
        ]
      },
      {
        "name": "Fiddle Leaf Fig",
        "image": "assets/images/plant8.jpg",
        "description": "Fiddle Leaf Fig is a trendy indoor plant with large, violin-shaped leaves, prized for its dramatic foliage and modern aesthetic. It is native to western Africa.",
        "careGuide": {
          "Sunlight": "Requires bright, indirect light but can tolerate some direct sunlight. Avoid sudden changes in light conditions.",
          "Watering": "Allow the top inch of soil to dry between waterings. Water more frequently during the growing season and less in winter.",
          "Soil": "Requires well-draining soil.",
          "Pruning": "Wipe the leaves occasionally to remove dust and promote photosynthesis."
        },
        "moreImages": [
          "assets/images/8.2.jpg",
          "assets/images/8.3.jpg",
          "assets/images/8.4.jpg"
        ]
      },
      {
        "name": "Rubber Plant",
        "image": "assets/images/plant9.jpg",
        "description": "Rubber Plant, or Ficus Elastica, is a classic indoor plant with glossy, burgundy-colored leaves, known for its air-purifying qualities and easy care. It is native to southeast Asia.",
        "careGuide": {
          "Sunlight": "Prefers bright, indirect light but can tolerate some shade. Avoid direct sunlight, as it can scorch the leaves.",
          "Watering": "Allow the top inch of soil to dry between waterings. Water less frequently in winter.",
          "Soil": "Requires well-draining soil.",
          "Pruning": "Prune leggy growth and wipe the leaves occasionally to remove dust buildup."
        },
        "moreImages": [
          "assets/images/9.2.jpg",
          "assets/images/9.3.jpg",
          "assets/images/9.4.jpg"
        ]
      },
      {
        "name": "Alocasia Polly",
        "image": "assets/images/plant10.jpg",
        "description": "Alocasia Polly, also known as African Mask Plant, is prized for its striking arrow-shaped leaves and distinctive veining. It adds a bold, tropical touch to indoor spaces and is relatively low-maintenance. It belongs to the Araceae family.",
        "careGuide": {
          "Sunlight": "Prefers bright, indirect light but can tolerate some direct sunlight. Avoid intense afternoon sun.",
          "Watering": "Keep the soil evenly moist but not waterlogged. Water when the top inch of soil feels dry.",
          "Soil": "Requires well-draining soil.",
          "Pruning": "Prune yellow or brown leaves to maintain plant health.",
        },
        "moreImages": [
          "assets/images/10.2.jpg",
          "assets/images/10.3.jpg",
          "assets/images/10.4.jpg"
        ]
      }
    ];


    return Scaffold(
      backgroundColor: Color(0xFFF3F7EB),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: _avatarUrl != null ? NetworkImage(_avatarUrl as String) : null,
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi $_userName',
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 4,
                          width: 100,
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Learn about Plants',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ),
              SizedBox(
                height: 260,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: plants.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlantDetailScreen(
                              plantName: plants[index]["name"],
                              plantImage: plants[index]["image"],
                              description: plants[index]["description"],
                              careGuide: plants[index]["careGuide"],
                              moreImages: plants[index]["moreImages"] ?? [],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        padding: EdgeInsets.all(20),
                        width: MediaQuery.of(context).size.width * 0.7,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                plants[index]["image"],
                                fit: BoxFit.cover,
                                height: 160,
                                width: 120,
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    plants[index]["name"],
                                    style: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    plants[index]["description"],
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Popular Plants',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.8,
                ),
                itemCount: popularPlants.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlantDetailScreen(
                            plantName: popularPlants[index]["name"],
                            plantImage: popularPlants[index]["image"],
                            description: popularPlants[index]["description"],
                            careGuide: plants[index]["careGuide"],
                            moreImages: popularPlants[index]["moreImages"] ?? [],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 20),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              popularPlants[index]["image"],
                              fit: BoxFit.cover,
                              height: 105,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  popularPlants[index]["name"],
                                  style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  popularPlants[index]["description"],
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _getScreenAtIndex(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.camera), label: 'Identify'),
          BottomNavigationBarItem(icon: Icon(Icons.photo_library), label: 'Gallery'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}