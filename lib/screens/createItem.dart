import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/common/toast.dart';

class CreateItem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreateItem();
}

class _CreateItem extends State<CreateItem> {
  late ImagePicker picker = ImagePicker();
  XFile? imagePicked;
  Uint8List? selectedImageBytes;
  var name = '';
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

  save() {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('collection');
    collection
        .add({'name': name, 'picture': image})
        .then((value) => showToast(message: 'Create Successfully!'))
        .catchError((error) => showToast(message: 'Error...$error'));
    Navigator.of(context).pop({name, image});
  }

  Future uploadFile() async {
    try {
      final path = 'files/${imagePicked!.name}';
      File file = File(imagePicked!.path);

      final ref = FirebaseStorage.instance.ref().child(path);
      UploadTask uploadTask = ref.putFile(file);
      final snapshot = await uploadTask.whenComplete(() {});
      image = await snapshot.ref.getDownloadURL();
      save();
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
                uploadFile();
                // collection
                //     .add({'name': name, 'picture': image})
                //     .then((value) => showToast(message: 'Create Successfully!'))
                //     .catchError(
                //         (error) => showToast(message: 'Error...$error'));
                // Navigator.of(context).pop({name, image});
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
                  hintText: 'Name Collection',
                  labelText: 'Collection'),
              onChanged: (value) {
                name = value;
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
          // TextFormField(
          //   decoration: const InputDecoration(
          //       icon: Icon(Icons.image),
          //       hintText: 'Select Img',
          //       labelText: 'Image'),
          //   onChanged: (value) {
          //     image = value;
          //   },
          // ),
          ElevatedButton(onPressed: selectFile, child: const Text('Tải ảnh'))
        ],
      ),
    );
  }
}
