import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:montoring_app/models/InverntoryItem.dart';

class InventoryPage extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();
  late TextEditingController nameController;
  late TextEditingController typeController;
  late TextEditingController quantityController;
  File? _image;
  String imageUrl = "";
  List<InventoryItem> inventoryItems = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    typeController = TextEditingController();
    quantityController = TextEditingController();
    fetchInventoryItems();
  }

  @override
  void dispose() {
    nameController.dispose();
    typeController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  Future<void> _getImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _getImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _saveInventoryItem() async {
    setState(() {
      isLoading = true;
    });

    final name = nameController.text;
    final type = typeController.text;
    final quantity = int.tryParse(quantityController.text) ?? 0;
    final dateAdded = DateTime.now();

    if (_image != null) {
      final fileName = 'inventory_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final destination = 'inventory_images/$fileName';

      try {
        final ref = firebase_storage.FirebaseStorage.instance.ref(destination);
        await ref.putFile(_image!);
        imageUrl = await ref.getDownloadURL();
      } catch (e) {
        print('Error uploading image: $e');
      }
    }

    final newItem = InventoryItem(
      id: DateTime.now().toString(),
      name: name,
      type: type,
      quantity: quantity,
      dateAdded: dateAdded,
      imageURL: imageUrl,
    );

    try {
      await firestore.collection('inventory').doc(newItem.id).set({
        'id': newItem.id,
        'name': newItem.name,
        'type': newItem.type,
        'quantity': newItem.quantity,
        'dateAdded': newItem.dateAdded,
        'imageURL': newItem.imageURL,
      });
      _resetFields();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Inventory item saved successfully!'),
        ),
      );
      fetchInventoryItems();
    } catch (e) {
      print('Error saving item: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving inventory item.'),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _resetFields() {
    nameController.clear();
    typeController.clear();
    quantityController.clear();
    setState(() {
      _image = null;
    });
  }

  Future<void> fetchInventoryItems() async {
    setState(() {
      isLoading = true;
    });

    try {
      final querySnapshot = await firestore.collection('inventory').get();
      final items = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return InventoryItem(
          id: data['id'],
          name: data['name'],
          type: data['type'],
          quantity: data['quantity'],
          dateAdded: (data['dateAdded'] as Timestamp).toDate(),
          imageURL: data['imageURL'],
        );
      }).toList();

      setState(() {
        inventoryItems = items;
      });
    } catch (e) {
      print('Error fetching inventory items: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _deleteInventoryItem(String itemId) async {
    try {
      await firestore.collection('inventory').doc(itemId).delete();
      fetchInventoryItems();
    } catch (e) {
      print('Error deleting item: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory Page'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : inventoryItems.isEmpty
              ? Center(
                  child: Text('No items available.'),
                )
              : ListView.builder(
                  itemCount: inventoryItems.length,
                  itemBuilder: (context, index) {
                    final item = inventoryItems[index];
                    return Dismissible(
                      key: Key(item.id),
                      onDismissed: (direction) {
                        _deleteInventoryItem(item.id);
                      },
                      background: Container(
                        color: Colors.red,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      child: ListTile(
                        title: Text(item.name),
                        subtitle: Text(
                            'Type: ${item.type}, Quantity: ${item.quantity}'),
                        leading: item.imageURL.isNotEmpty
                            ? Image.network(
                                item.imageURL,
                                width: 50,
                                height: 50,
                              )
                            : SizedBox(),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemDialog,
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Inventory Item'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextFormField(
                  controller: typeController,
                  decoration: InputDecoration(labelText: 'Type'),
                ),
                TextFormField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Quantity'),
                ),
                SizedBox(height: 16),
                _image != null
                    ? Image.file(_image!, height: 150)
                    : Text('If you have a Receipt'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: _getImageFromGallery,
                      child: Text('Import'),
                    ),
                    ElevatedButton(
                      onPressed: _getImageFromCamera,
                      child: Text('Take Photo'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    typeController.text.isNotEmpty &&
                    quantityController.text.isNotEmpty) {
                  _saveInventoryItem();
                  Navigator.of(context).pop();
                }
              },
              child: Text('Save'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
