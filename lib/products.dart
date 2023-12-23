import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop_app_flutter/navBtn.dart';
import 'model/specialOfferProducts.dart';
import 'singleProduct.dart';
import 'package:dio/dio.dart';
import 'main.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  late Future<List<SpecialOfferProduct>> specialOfferFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    specialOfferFuture = sendRequestSpecialOffer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: NavBtn(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ));
        },
        child: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ));
          },
          icon: Icon(Icons.home_outlined),
          color: Colors.red,
          isSelected: false,
          selectedIcon: Icon(Icons.home),
        ),
        backgroundColor: Colors.white,
        shape: CircleBorder(eccentricity: 0),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      appBar: AppBar(
        backgroundColor: Colors.red,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        title: Text("Products"),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15))),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: RefreshIndicator(
            onRefresh: sendRequestSpecialOffer,
            child: FutureBuilder<List<SpecialOfferProduct>>(
              future: specialOfferFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<SpecialOfferProduct>? data = snapshot.data;
                  return GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: List.generate(
                      data!.length,
                      (index) => productListItem(data[index]),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("No Products"),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.red,
                      strokeWidth: 1,
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  InkWell productListItem(SpecialOfferProduct specialOfferProduct) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SingleProduct(specialOfferProduct)));
      },
      child: Card(
        color: Colors.white,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      specialOfferProduct.img,
                      fit: BoxFit.fitHeight,
                      height: 150,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return Center(
                            child: CircularProgressIndicator(
                              color: Colors.red,
                              strokeWidth: 1,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: Text(
                      specialOfferProduct.title.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    )),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SingleProduct(specialOfferProduct)));
                    },
                    child: Text(
                      "Price: " + specialOfferProduct.price.toString() + "\$",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<SpecialOfferProduct>> sendRequestSpecialOffer() async {
    List<SpecialOfferProduct> model = [];
    var api = "https://fakestoreapi.com/products";
    var response = await Dio().get(api);
    var counter = 0;
    for (var item in response.data) {
      model.add(SpecialOfferProduct(
          item["id"],
          item["title"],
          item['price'],
          item['price'],
          item["image"],
          item["description"],
          item["category"],
          item["rating"]["rate"],
          item["rating"]["count"]));
      counter += 1;
      if (counter == 8) {
        break;
      }
    }
    return model;
  }
}
