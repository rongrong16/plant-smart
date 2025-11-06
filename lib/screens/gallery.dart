import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({Key? key}) : super(key: key);

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> deletePlant(String documentId) async {
    await _firestore.collection('plants').doc(documentId).delete();
  }

  @override
  Widget build(BuildContext context) {
    final double imageHeight = 150;
    final double titleHeight = 60;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Gallery'),
        backgroundColor: Color(0xFFF3F7EB),
      ),
      backgroundColor: Color(0xFFF3F7EB),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('plants').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
              childAspectRatio: MediaQuery.of(context).size.width / (imageHeight + titleHeight) / 2.2,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var plant = snapshot.data!.docs[index];
              return Card(
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: imageHeight,
                          width: double.infinity,
                          child: Image.network(
                            plant.get('imageUrl'),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                          ),
                        ),
                        Container(
                          height: titleHeight,
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                plant.get('commonName'),
                                style: Theme.of(context).textTheme.bodyLarge,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                plant.get('scientificName'),
                                style: Theme.of(context).textTheme.bodyMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red), // Set color to red
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Delete Plant"),
                                content: Text("Are you sure you want to delete this plant?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      deletePlant(plant.id);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Delete"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
