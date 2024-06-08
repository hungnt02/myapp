// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

import 'package:myapp/common/toast.dart';
import 'package:myapp/models/collection.dart';
import 'package:myapp/models/item.dart';
import 'package:myapp/models/user.dart';

class Edititem extends StatefulWidget {
  final Item itemData;
  final Collection data;
  const Edititem({
    Key? key,
    required this.itemData,
    required this.data,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _Edititem(itemData);
}

class _Edititem extends State<Edititem> {
  final Item item;
  late TextEditingController viController;
  late TextEditingController enController;

  late ImagePicker picker = ImagePicker();
  XFile? imagePicked;
  Uint8List? selectedImageBytes;
  var vi = '';
  var en = '';
  var image = '';

  _Edititem(this.item);

  void initState() {
    super.initState();
    viController = TextEditingController(text: widget.itemData.vi);
    enController = TextEditingController(text: widget.itemData.en);
    vi = item.vi;
    en = item.en;
    image = item.image;
    picker = ImagePicker();
  }

  Future selectFile() async {
    final result = await picker.pickImage(source: ImageSource.gallery);
    final bytesImage = await result?.readAsBytes();
    setState(() {
      selectedImageBytes = bytesImage;
      imagePicked = result;
    });
  }

  Future save(String nameCollection, String document) async {
    if (imagePicked != null) {
      await uploadFile();
    }
    CollectionReference collection =
        FirebaseFirestore.instance.collection(nameCollection);
    collection
        .doc(document)
        .update({'vi': vi, 'en': en, 'picture': image})
        .then((value) => showToast(message: 'Create Successfully!'))
        .catchError((error) => showToast(message: 'Error...$error'));
    Navigator.of(context).pop();
  }

  Future uploadFile() async {
    try {
      Reference _reference = FirebaseStorage.instance
          .ref()
          .child('images/${Path.basename(imagePicked!.path)}');
      await _reference
          .putData(
        await imagePicked!.readAsBytes(),
        SettableMetadata(contentType: 'image/jpg'),
      )
          .whenComplete(() async {
        await _reference.getDownloadURL().then((value) {
          image = value;
        });
      });
    } catch (error) {
      print('error........${error}');
    }
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('collection');
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm Mới'),
        actions: [
          IconButton(
              onPressed: () {
                save(widget.data.id, widget.itemData.id);
              },
              icon: const Icon(Icons.save))
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child: TextFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Tiếng Việt',
                  labelText: 'Tiêng Việt'),
              controller: viController,
              onChanged: (value) {
                vi = value;
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: TextFormField(
              decoration: const InputDecoration(
                  // icon: Icon(Icons.),
                  border: OutlineInputBorder(),
                  hintText: 'Tiếng Anh',
                  labelText: 'Tiêng Anh'),
              controller: enController,
              onChanged: (value) {
                en = value;
              },
            ),
          ),
          imagePicked == null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.network(
                    image,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.memory(
                    selectedImageBytes!,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
          ElevatedButton(onPressed: selectFile, child: const Text('Tải ảnh'))
        ],
      ),
    );
  }
}
