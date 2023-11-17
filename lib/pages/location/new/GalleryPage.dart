import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:line_icons/line_icons.dart';

import 'package:montoring_app/models/Place.dart';
import 'package:path_provider/path_provider.dart';

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
  late AppLocalizations l;

  @override
  void didChangeDependencies() {
    l = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  Future getImageFromCamera() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 25);

    if (pickedFile != null) {
      File? newImage = await saveImageToTemporaryDirectory(pickedFile);
      if (newImage != null) {
        setState(() {
          _images.add(newImage);
        });
        uploadImage(newImage.path);
      }
    }
  }

  Future getImageFromGallery() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 25);

    if (pickedFile != null) {
      File? newImage = await saveImageToTemporaryDirectory(pickedFile);
      if (newImage != null) {
        setState(() {
          _images.add(newImage);
        });
        uploadImage(newImage.path);
      }
    }
  }

  Future<File?> saveImageToTemporaryDirectory(XFile pickedFile) async {
    try {
      final directory = await getTemporaryDirectory();
      String filePath = '${directory.path}/${DateTime.now()}.jpg';
      File newImage = File(pickedFile.path);
      File copiedImage = await newImage.copy(filePath);
      return copiedImage;
    } catch (e) {
      debugPrint('Error saving image to temporary directory: $e');
      return null;
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
      debugPrint('Error loading images: $e');
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
      debugPrint('Error uploading image: $e');
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
      debugPrint('Error saving image URL: $e');
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
      debugPrint('Error updating images in Firestore: $e');
    }
  }

  void showdialogg(double latitude, double longitude) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.deleteText),
        content: Text(l.areYouSureDelete),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(l.deleteText),
          ),
        ],
      ),
    );
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
      debugPrint('Error removing image URL from Firestore: $e');
    }
  }

  void viewImage(int index) {
    if (index < _onlineImages.length) {
      _showImageDialog(context, _onlineImages[index]);
    } else {
      _showImageDialog(context, _images[index - _onlineImages.length].path);
    }
  }

  void _showImageDialog(BuildContext context, String imagePath) {
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
            child: _isOnlineImage(imagePath)
                ? Image.network(
                    imagePath,
                    fit: BoxFit.contain,
                  )
                : Image.file(
                    File(imagePath),
                    fit: BoxFit.contain,
                  ),
          ),
        ),
      ),
    );
  }

  bool _isOnlineImage(String imagePath) {
    return imagePath.startsWith('http');
  }

  @override
  void initState() {
    super.initState();
    loadImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(l.galleryText),
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
                      child: Icon(Icons.camera),
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
                      child: Icon(LineIcons.image),
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
