import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:miaged/ui/search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miaged/const/AppColors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../product_details_screen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> _carouselImages = [];
  var _dotPosition = 0;
  List _products = [];
  var _firestoreInstance = FirebaseFirestore.instance;
  TextEditingController _searchController = TextEditingController();

  fetchCarouselImages() async {
    QuerySnapshot qn =
        await _firestoreInstance.collection("carousel-slider").get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _carouselImages.add(
          qn.docs[i]["img-path"],
        );
        print(qn.docs[i]["img-path"]);
      }
    });

    return qn.docs;
  }

  fetchProducts() async {
    QuerySnapshot qn = await _firestoreInstance.collection("products").get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _products.add({
          "product-titre": qn.docs[i]["product-titre"],
          "product-taille": qn.docs[i]["product-taille"],
          "product-marque": qn.docs[i]["product-marque"],
          "product-prix": qn.docs[i]["product-prix"],
          "product-img": qn.docs[i]["product-img"],
        });
      }
    });

    return qn.docs;
  }

  @override
  void initState() {
    fetchCarouselImages();
    fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 60.h,
                      child: TextFormField(
                        controller: _searchController,
                        readOnly: true,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(0)),
                              borderSide: BorderSide(color: Colors.blue)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(0)),
                              borderSide: BorderSide(color: Colors.grey)),
                          hintText: "Search products here",
                          hintStyle: TextStyle(fontSize: 15.sp),
                        ),
                        onTap: () => Navigator.push(context,
                            CupertinoPageRoute(builder: (_) => SearchScreen())),
                      ),
                    ),
                  ),
                  Container(
                    height: 60.h,
                    width: 60.h,
                    color: AppColors.vinted_color,
                    child: Center(
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Expanded(
              child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: _products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 0.8),
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetails(_products[index]))),
                      child: Card(
                        elevation: 3,
                        child: Column(
                          children: [
                            AspectRatio(
                                aspectRatio: 1.2,
                                child: Container(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    child: Image.network(
                                      _products[index]["product-img"][0],
                                    ))),
                            Text("${_products[index]["product-titre"]}"),
                            Text("${_products[index]["product-taille"]}"),
                            Text("${_products[index]["product-marque"]}"),
                            Text(
                                "${_products[index]["product-prix"].toString()}"),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      )),
    );
  }
}
