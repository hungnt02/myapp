// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

import 'package:myapp/common/toast.dart';
import 'package:myapp/models/collection.dart';
import 'package:myapp/models/user.dart';

class EditCollection extends StatefulWidget {
  final UserModel user;
  final Collection data;
  const EditCollection({
    Key? key,
    required this.user,
    required this.data,
  }) : super(key: key);

  State<StatefulWidget> createState() => _EditCollection(data);
}

class _EditCollection extends State<EditCollection> {
  late TextEditingController namController;
  final Collection collect;
  late ImagePicker picker = ImagePicker();
  XFile? imagePicked;
  Uint8List? selectedImageBytes;
  var name = '';
  var image = '';

  _EditCollection(this.collect);

  void initState() {
    super.initState();
    picker = ImagePicker();
    name = collect.name;
    image = collect.image;
    namController = TextEditingController(text: collect.name);
  }

  Future selectFile() async {
    final result = await picker.pickImage(source: ImageSource.gallery);
    final bytesImage = await result?.readAsBytes();
    setState(() {
      selectedImageBytes = bytesImage;
      imagePicked = result;
    });
  }

  Future save(Collection collectData, UserModel user) async {
    if (imagePicked != null) {
      uploadFile();
    }
    CollectionReference collection =
        FirebaseFirestore.instance.collection(user.email ?? 'default');
    collection
        .doc(collectData.id)
        .update({'name': name, 'picture': image})
        .then((value) => showToast(message: 'Create Successfully!'))
        .catchError((error) => showToast(message: 'Error...$error'));
    Navigator.of(context).pop();
  }

  delete(String nameCollection, String nameDocument) {
    CollectionReference collection =
        FirebaseFirestore.instance.collection(nameCollection);
    collection.doc(nameDocument).delete();
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
        title: Text('Sửa'),
        actions: [
          IconButton(
              onPressed: () {
                save(widget.data, widget.user);
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
                  hintText: 'Name Collection',
                  labelText: 'Collection'),
              controller: namController,
              onChanged: (value) {
                name = value;
              },
            ),
          ),
          imagePicked == null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.network(
                    widget.data.image,
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
          Container(
            margin: const EdgeInsets.all(20),
          ),
          ElevatedButton(onPressed: selectFile, child: const Text('Tải ảnh')),
          Container(
            margin: const EdgeInsets.all(20),
          ),
          ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Xác nhận xóa"),
                      content: const Text("Bạn có chắc xóa mục này?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("Hủy"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text("Xóa"),
                        ),
                      ],
                    );
                  },
                ).then((confirmed) {
                  if (confirmed) {
                    delete(widget.user.email ?? 'default', widget.data.id);
                  }
                });
              },
              child: const Text('Xóa'))
        ],
      ),
    );
  }
}
// delete(widget.user.email ?? 'default', widget.data.id)