import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController? _nomController;
  TextEditingController? _emailController;
  TextEditingController? _prenomController;
  TextEditingController? _adresseController;
  TextEditingController? _codepController;
  TextEditingController? _villeController;
  final FirebaseAuth auth = FirebaseAuth.instance;

  setDataToTextField(data) {
    return Column(
      children: [
        TextFormField(
          controller: _emailController =
              TextEditingController(text: auth.currentUser!.email),
          decoration: InputDecoration(
            labelText: 'Email',
            labelStyle: TextStyle(
              fontSize: 15.sp,
              color: Colors.black,
            ),
          ),
          readOnly: true,
        ),
        TextFormField(
          controller: _nomController = TextEditingController(text: data['nom']),
          decoration: InputDecoration(
            labelText: 'nom',
            labelStyle: TextStyle(
              fontSize: 15.sp,
              color: Colors.black,
            ),
          ),
        ),
        TextFormField(
          controller: _prenomController =
              TextEditingController(text: data['prenom']),
          decoration: InputDecoration(
            labelText: 'prenom',
            labelStyle: TextStyle(
              fontSize: 15.sp,
              color: Colors.black,
            ),
          ),
        ),
        TextFormField(
          controller: _adresseController =
              TextEditingController(text: data['address']),
          decoration: InputDecoration(
            labelText: 'address',
            labelStyle: TextStyle(
              fontSize: 15.sp,
              color: Colors.black,
            ),
          ),
        ),
        TextFormField(
          controller: _codepController =
              TextEditingController(text: data['codep']),
          decoration: InputDecoration(
            labelText: 'code postal',
            labelStyle: TextStyle(
              fontSize: 15.sp,
              color: Colors.black,
            ),
          ),
        ),
        TextFormField(
          controller: _villeController =
              TextEditingController(text: data['ville']),
          decoration: InputDecoration(
            labelText: 'ville',
            labelStyle: TextStyle(
              fontSize: 15.sp,
              color: Colors.black,
            ),
          ),
        ),
        ElevatedButton(onPressed: () => updateData(), child: Text("Update"))
      ],
    );
  }

  updateData() {
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users");
    return _collectionRef.doc(FirebaseAuth.instance.currentUser!.email).update({
      "nom": _nomController!.text,
      "prenom": _prenomController!.text,
      "address": _adresseController!.text,
      "codep": _codepController!.text,
      "ville": _villeController!.text,
    }).then((value) => print("Updated Successfully"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.email)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            var data = snapshot.data;
            if (data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return setDataToTextField(data);
          },
        ),
      )),
    );
  }
}
