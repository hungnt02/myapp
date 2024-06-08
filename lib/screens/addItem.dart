// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';
import 'package:path/path.dart' as Path;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:myapp/common/toast.dart';
import 'package:myapp/models/collection.dart';
import 'package:myapp/models/user.dart';

class AddItem extends StatefulWidget {
  final Collection data;
  const AddItem({
    Key? key,
    required this.data,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _AddItem();
}

class _AddItem extends State<AddItem> {
  late ImagePicker picker = ImagePicker();
  XFile? imagePicked;
  Uint8List? selectedImageBytes;
  var vi = '';
  var en = '';
  var image = '';

  void initState() {
    super.initState();
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

  save(String nameCollection) {
    CollectionReference collection =
        FirebaseFirestore.instance.collection(nameCollection);
    collection
        .add({'vi': vi, 'en': en, 'picture': image})
        .then((value) => showToast(message: 'Create Successfully!'))
        .catchError((error) => showToast(message: 'Error...$error'));
    Navigator.of(context).pop();
  }

  Future uploadFile(String collection) async {
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
      save(collection);
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
                uploadFile(widget.data.id ?? 'default');
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
                  // icon: Icon(Icons.),
                  border: OutlineInputBorder(),
                  hintText: 'Tiếng Việt',
                  labelText: 'Tiêng Việt'),
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
              onChanged: (value) {
                en = value;
              },
            ),
          ),
          imagePicked == null
              ? const Text('Bạn chưa chọn ảnh!')
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
