import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:myapp/common/toast.dart';
import 'package:myapp/models/collection.dart';
import 'package:myapp/screens/createItem.dart';

class ListingPage extends StatefulWidget {
  const ListingPage({super.key});

  @override
  State<ListingPage> createState() => _ListingPage();
}

class _ListingPage extends State<ListingPage> {
  final Stream<QuerySnapshot> collection =
      FirebaseFirestore.instance.collection('collection').snapshots();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 1000,
          height: 80,
          color: Color.fromARGB(255, 243, 197, 170),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Collection',
                  style: TextStyle(
                      fontWeight: FontWeight.w100,
                      color: Colors.white,
                      fontSize: 20),
                ),
              ),
              IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => CreateItem(),
                    );
                  },
                  icon: const Icon(Icons.add))
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
              stream: collection,
              builder: (
                BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot,
              ) {
                if (snapshot.hasError) {
                  showToast(message: 'Something went wong! ');
                }

                final data = snapshot.requireData;
                return GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                  ),
                  primary: false,
                  shrinkWrap: true,
                  children: [
                    ListView.builder(
                      itemBuilder: (context, index) {
                        return index < data.docs.length
                            ? HoverContainer(
                                height: 120,
                                hoverDecoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  color: Color.fromARGB(255, 224, 178, 178),
                                ),
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  color: Color.fromARGB(255, 228, 210, 210),
                                ),
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.only(
                                    top: 20, right: 30, left: 30),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Image.network(
                                        '${data.docs[index]['picture']}',
                                        width: 100.0,
                                        height: 90.0,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 20),
                                      child: Text('${data.docs[index]['name']}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20)),
                                    ),
                                  ],
                                ))
                            : null;
                      },
                    )
                  ],
                );
              }),
        ),
      ],
    );
  }
}
