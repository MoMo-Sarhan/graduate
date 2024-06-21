// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:graduate/services/user_data_services.dart';

class RatingPage extends StatefulWidget {
  const RatingPage({super.key});

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  List<String> rateImage = [
    'assets/images/rate_icons/0.gif',
    'assets/images/rate_icons/1.png',
    'assets/images/rate_icons/2.png',
    'assets/images/rate_icons/3.png',
    'assets/images/rate_icons/4.png',
    'assets/images/rate_icons/5.png',
  ];
  double rate = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rate App'),
        centerTitle: true,
      ),
      body: Center(
          child: Column(
        children: [
          Spacer(
            flex: 1,
          ),
          _getRate(),
          RatingBar.builder(
              initialRating: rate,
              allowHalfRating: true,
              direction: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
              onRatingUpdate: (value) {
                setState(() {
                  rate = value;
                });
              }),
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              '$rate',
              style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: rate == 5 ? Colors.amber : Colors.black),
            ),
          ),
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 40,
            child: Image(image: AssetImage(rateImage[rate.toInt()])),
          ),
          Spacer(
            flex: 2,
          ),
          ElevatedButton(
              onPressed: () async {
                await UserServices().rateApp(
                    rate: rate, uid: FirebaseAuth.instance.currentUser!.uid);
                Navigator.pop(context);
              },
              child: Text(
                'Submit',
              )),
          Spacer(
            flex: 3,
          ),
        ],
      )),
    );
  }

  Widget _getRate() {
    return StreamBuilder(
        stream: UserServices().getRate(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('error'),
            );
          }
          return Center(
            child: Text(_getRateData(snapshot.data!.docs).toStringAsFixed(1)),
          );
        });
  }

  double _getRateData(List<DocumentSnapshot> docs) {
    log(docs.length.toString());
    double allRate = 0;
    int counter = docs.length;
    for (var doc in docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      allRate += data['rate'];
    }
    return allRate / counter;
  }
}
