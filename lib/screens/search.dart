import 'package:flutter/material.dart';
import 'package:plantsmart/screens/plantdetails.dart';


class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<Map<String, dynamic>> _plants = [
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

  List<Map<String, dynamic>> _popularPlants = [
    {
      "name": "ZZ Plant",
      "image": "assets/images/plant6.jpg",
      "description": "ZZ Plant, or Zamioculcas Zamiifolia, is a resilient and drought-tolerant plant with glossy green foliage, perfect for beginners. It is also known as the Zanzibar Gem.",
      "careGuide": {
        "Sunlight": "Thrives in low to moderate indirect light but can tolerate low light conditions. Avoid direct sunlight.",
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

  List<Map<String, dynamic>> _foundPlants = [];

  @override
  void initState() {
    _foundPlants = _plants + _popularPlants;
    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    setState(() {
      if (enteredKeyword.isEmpty) {
        _foundPlants = _plants + _popularPlants;
      } else {
        _foundPlants = (_plants + _popularPlants)
            .where((plant) =>
            plant["name"].toLowerCase().contains(enteredKeyword.toLowerCase()))
            .toList();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Plants Here'),
        backgroundColor: Color(0xFFF3F7EB),
      ),
      backgroundColor: Color(0xFFF3F7EB),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: _runFilter,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _foundPlants.isNotEmpty
                  ? GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.75,
                ),
                itemCount: _foundPlants.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlantDetailScreen(
                            plantName: _foundPlants[index]["name"],
                            plantImage: _foundPlants[index]["image"],
                            description: _foundPlants[index]["description"],
                            careGuide: _foundPlants[index]["careGuide"],
                            moreImages: _foundPlants[index]["moreImages"] ?? [],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                              child: Image.asset(
                                _foundPlants[index]["image"],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              _foundPlants[index]["name"],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
                  : Center(
                child: Text(
                  'No results found',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}