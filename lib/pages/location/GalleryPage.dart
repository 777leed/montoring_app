import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

import 'package:montoring_app/models/Place.dart';

class GalleryPage extends StatefulWidget {
  final String? placeId;
  final Place? place;

  GalleryPage({required this.placeId, required this.place});

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final picker = ImagePicker();
  List<String> _onlineImages = [];
  List<File> _images = [];

  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
      uploadImage(pickedFile.path);
    }
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
      uploadImage(pickedFile.path);
    }
  }

  Future<void> loadImages() async {
    try {
      final placeRef =
          FirebaseFirestore.instance.collection('places').doc(widget.placeId);
      final placeDoc = await placeRef.get();
      if (placeDoc.exists) {
        final data = placeDoc.data() as Map<String, dynamic>;
        if (data.containsKey('images')) {
          final onlineImages = data['images'] as List<dynamic>;
          setState(() {
            _onlineImages = onlineImages.cast<String>().toList();
          });
        }
      }
    } catch (e) {
      print('Error loading images: $e');
    }
  }

  Future<void> uploadImage(String filePath) async {
    try {
      final storage = FirebaseStorage.instance;
      final ref =
          storage.ref().child('images/${widget.placeId}/${DateTime.now()}.jpg');
      final uploadTask = ref.putFile(File(filePath));

      await uploadTask.whenComplete(() => null);

      final imageUrl = await ref.getDownloadURL();
      saveImageUrlToFirestore(imageUrl);
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> saveImageUrlToFirestore(String imageUrl) async {
    try {
      final placeRef =
          FirebaseFirestore.instance.collection('places').doc(widget.placeId);
      await placeRef.update({
        'images': FieldValue.arrayUnion([imageUrl]),
      });
    } catch (e) {
      print('Error saving image URL: $e');
    }
  }

  Future<void> updateImagesInFirestore(List<String> updatedImages) async {
    try {
      final placeRef =
          FirebaseFirestore.instance.collection('places').doc(widget.placeId);
      await placeRef.update({
        'images': updatedImages,
      });
    } catch (e) {
      print('Error updating images in Firestore: $e');
    }
  }

  void removeImage(int index) {
    setState(() {
      if (index < _onlineImages.length) {
        _onlineImages.removeAt(index);
      } else {
        _images.removeAt(index - _onlineImages.length);
      }
    });

    final updatedImages = [
      ..._onlineImages,
      ..._images.map((image) => image.path)
    ];
    updateImagesInFirestore(updatedImages);
  }

  Future<void> removeImageFromFirestore(String imageUrl) async {
    try {
      final placeRef =
          FirebaseFirestore.instance.collection('places').doc(widget.placeId);
      await placeRef.update({
        'images': FieldValue.arrayRemove([imageUrl]),
      });
    } catch (e) {
      print('Error removing image URL from Firestore: $e');
    }
  }

  void viewImage(int index) {
    if (index < _onlineImages.length) {
      _showImageDialog(context, _onlineImages[index]);
    } else {
      _showImageDialog(context, _images[index - _onlineImages.length].path);
    }
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            width: double.infinity,
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                  ),
                  itemCount: _onlineImages.length + _images.length,
                  itemBuilder: (context, index) {
                    if (index < _onlineImages.length) {
                      return GestureDetector(
                        onTap: () => viewImage(index),
                        child: Stack(
                          children: [
                            Container(
                                width: 150,
                                clipBehavior: Clip.antiAlias,
                                height: 150,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Image.network(
                                  _onlineImages[index],
                                  fit: BoxFit.cover,
                                )),
                            Positioned(
                              top: 5,
                              right: 5,
                              child: IconButton(
                                icon: Icon(Icons.remove_circle),
                                onPressed: () => removeImage(index),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return GestureDetector(
                        onTap: () => viewImage(index),
                        child: Stack(
                          children: [
                            Container(
                                width: 150,
                                clipBehavior: Clip.antiAlias,
                                height: 150,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Image.file(
                                  _images[index - _onlineImages.length],
                                  fit: BoxFit.cover,
                                )),
                            Positioned(
                              top: 5,
                              right: 5,
                              child: IconButton(
                                icon: Icon(Icons.remove_circle),
                                onPressed: () => removeImage(index),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    onTap: getImageFromCamera,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      width: 120,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Take Picture',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: getImageFromGallery,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      width: 120,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Import Images',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
