// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stacked_card_carousel/stacked_card_carousel.dart';

import 'package:myapp/models/collection.dart';
import 'package:myapp/models/item.dart';
import 'package:myapp/screens/addItem.dart';
import 'package:myapp/screens/editItem.dart';

class SlicePage extends StatefulWidget {
  final Collection data;
  const SlicePage({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SlicePage(data);
}

class _SlicePage extends State<SlicePage> {
  final Collection collectionData;

  _SlicePage(this.collectionData);
  @override
  Widget build(BuildContext context) {
    // final Stream<QuerySnapshot> collection =
    //     FirebaseFirestore.instance.collection(collectionData.id).snapshots();
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.data.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => AddItem(
                      data: widget.data,
                    ),
                  );
                },
                icon: const Icon(Icons.add))
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(widget.data.id)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final data = snapshot.requireData;
              final List<Widget> cart = [];
              for (int i = 0; i < data.docs.length; i++) {
                cart.add(FancyCard(
                  data: widget.data,
                  id: data.docs[i].id,
                  image: data.docs[i]['picture'],
                  vi: data.docs[i]['vi'],
                  en: data.docs[i]['en'],
                ));
              }
              if (cart.length == 0) {
                return const Center(
                  child: Text('Data is Empty!'),
                );
              } else {
                return StackedCardCarousel(items: cart);
              }
            }));
  }
}

class FancyCard extends StatefulWidget {
  final Collection data;
  const FancyCard({
    Key? key,
    required this.data,
    required this.id,
    required this.image,
    required this.vi,
    required this.en,
  }) : super(key: key);
  final String id;
  final String image;
  final String vi;
  final String en;

  @override
  State<StatefulWidget> createState() => _FancyCard();
}

class _FancyCard extends State<FancyCard> {
  late bool vn = true;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  showBottomSheet(
                      context: context,
                      builder: (context) => Edititem(
                          itemData: Item(
                              id: widget.id,
                              vi: widget.vi,
                              en: widget.en,
                              image: widget.image),
                          data: widget.data));
                },
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  if (!vn) {
                    vn = true;
                  } else {
                    vn = false;
                  }
                });
              },
              child: Container(
                width: 250,
                height: 250,
                child: Image.network(
                  widget.image,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5),
              child: Text(
                vn ? widget.vi : widget.en,
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
