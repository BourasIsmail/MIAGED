import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miaged/const/AppColors.dart';
import 'package:miaged/ui/bottom_nav_controller.dart';
import 'package:miaged/widgets/customButton.dart';
import 'package:miaged/widgets/myTextField.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  TextEditingController _nomController = TextEditingController();
  TextEditingController _prenomController = TextEditingController();
  TextEditingController _datenController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _codepController = TextEditingController();
  TextEditingController _villeController = TextEditingController();

  Future<void> _selectDateFromPicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year - 20),
      firstDate: DateTime(DateTime.now().year - 30),
      lastDate: DateTime(DateTime.now().year),
    );
    if (picked != null)
      setState(() {
        _datenController.text =
            "${picked.day}/ ${picked.month}/ ${picked.year}";
      });
  }

  sendUserDataToDB() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;

    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users");
    return _collectionRef
        .doc(currentUser!.email)
        .set({
          "nom": _nomController.text,
          "prenom": _prenomController.text,
          "daten": _datenController.text,
          "address": _addressController.text,
          "codep": _codepController.text,
          "ville": _villeController.text,
        })
        .then((value) => Navigator.push(
            context, MaterialPageRoute(builder: (_) => BottomNavController())))
        .catchError((error) => print("something is wrong. $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  "Submit the form to continue.",
                  style:
                      TextStyle(fontSize: 22.sp, color: AppColors.vinted_color),
                ),
                Text(
                  "We will not share your information with anyone.",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Color(0xFFBBBBBB),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                myTextField("Nom", TextInputType.text, _nomController),
                myTextField("Prenom", TextInputType.text, _prenomController),
                myTextField("Address", TextInputType.text, _addressController),
                myTextField(
                    "Code postal", TextInputType.number, _codepController),
                myTextField("Ville", TextInputType.text, _villeController),

                TextField(
                  controller: _datenController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "date de naissance",
                    suffixIcon: IconButton(
                      onPressed: () => _selectDateFromPicker(context),
                      icon: Icon(Icons.calendar_today_outlined),
                    ),
                  ),
                ),

                SizedBox(
                  height: 50.h,
                ),

                // elevated button
                customButton("Continue", () => sendUserDataToDB()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
