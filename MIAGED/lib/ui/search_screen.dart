import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:miaged/ui/login_screen.dart';
import 'package:miaged/const/AppColors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var inputText = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.vinted_color,
        title: Text(" MIAGED  "),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              }).onError((error, stackTrace) {
                Fluttertoast.showToast(msg: error.toString());
              });
            },
            icon: Icon(Icons.logout_outlined),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  hintText: "nom de produit",
                  hintStyle: TextStyle(
                    fontSize: 14.sp,
                    color: Color(0xFF414041),
                  ),
                  labelText: 'Recherche',
                  labelStyle: TextStyle(
                    fontSize: 15.sp,
                    color: AppColors.vinted_color,
                  ),
                ),
                onChanged: (val) {
                  setState(() {
                    inputText = val;
                    print(inputText);
                  });
                },
              ),
              Expanded(
                child: Container(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("products")
                          .orderBy("product-titre")
                          .where("product-titre",
                              isGreaterThanOrEqualTo: inputText.toLowerCase())
                          .where("product-titre",
                              isLessThanOrEqualTo:
                                  inputText.toLowerCase() + "\uf8ff")
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text("Something went wrong"),
                          );
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: Text("Loading"),
                          );
                        }

                        return ListView(
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data() as Map<String, dynamic>;
                            return Card(
                              elevation: 5,
                              child: ListTile(
                                title: Text(data['product-titre']),
                                leading: Image.network(data['product-img'][0]),
                              ),
                            );
                          }).toList(),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
