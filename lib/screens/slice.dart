// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screens/addItem.dart';
import 'package:stacked_card_carousel/stacked_card_carousel.dart';

import 'package:myapp/models/collection.dart';

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
  // final List<Widget> fancyCards = <Widget>[
  //   FancyCard(
  //     image: Image.asset("assets/pluto-done.png"),
  //     title: "Say hello to planets!",
  //   ),
  //   FancyCard(
  //     image: Image.asset("assets/pluto-fatal-error.png"),
  //     title: "Don't be sad!",
  //   ),
  //   FancyCard(
  //     image: Image.asset("assets/pluto-coming-soon.png"),
  //     title: "Go for a walk!",
  //   ),
  //   FancyCard(
  //     image: Image.asset("assets/pluto-sign-up.png"),
  //     title: "Try teleportation!",
  //   ),
  //   FancyCard(
  //     image: Image.asset("assets/pluto-waiting.png"),
  //     title: "Enjoy your coffee!",
  //   ),
  //   FancyCard(
  //     image: Image.asset("assets/pluto-welcome.png"),
  //     title: "Play with your cat!",
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    // final Stream<QuerySnapshot> collection =
    //     FirebaseFirestore.instance.collection(collectionData.id).snapshots();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Slider!'),
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
                icon: Icon(Icons.add))
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(widget.data.id)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              final data = snapshot.requireData;
              final List<Widget> cart = [];
              for (int i = 0; i < data.docs.length; i++) {
                cart.add(FancyCard(
                  image: Image.network(data.docs[i]['picture']),
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
  const FancyCard({
    super.key,
    required this.image,
    required this.vi,
    required this.en,
  });
  final Image image;
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
                child: widget.image,
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
