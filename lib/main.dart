import 'package:flutter/material.dart';
import 'package:whats_app/Home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whats_app/pages/Cadastro.dart';
import 'package:whats_app/pages/Login.dart';

void main() {
 // Firestore.instance.collection("usuarios").document("001").setData({"nome":"Jamiltom"});
  runApp(MaterialApp(
    home: Login(),
    theme: ThemeData(
      primaryColor: Color(0xff075E54),
      accentColor: Color(0xff25D366)
    ),
    debugShowCheckedModeBanner: false,
  ));
}
