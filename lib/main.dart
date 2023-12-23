import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_app_flutter/navBtn.dart';
import 'package:shop_app_flutter/orders.dart';
import 'package:shop_app_flutter/products.dart';
import 'package:shop_app_flutter/singleProduct.dart';
import 'model/slidersModel.dart';
import 'model/specialOfferProducts.dart';
import 'package:dio/dio.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(
    MaterialApp(
      home: const HomePage(),
      theme: ThemeData(useMaterial3: true),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<SliderModel>> sliderFuture;
  late Future<List<SpecialOfferProduct>> specialOfferFuture;
  PageController sliderController = PageController();
  final CircularProgressIndicator circularProgressIndicator =
      CircularProgressIndicator(
    color: Colors.red,
    strokeWidth: 1.0,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sliderFuture = sendRequestSlider();
    specialOfferFuture = sendRequestSpecialOffer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: NavBtn(),
      floatingActionButton: FloatingActionButton(
        tooltip: "Home",
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
          isSelected: true,
          selectedIcon: Icon(Icons.home),
        ),
        backgroundColor: Colors.white,
        shape: CircleBorder(eccentricity: 0),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      appBar: AppBar(
        title: const Text("Azerbaijan Shop"),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        backgroundColor: Colors.red,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Image.network(
            "https://th.bing.com/th/id/OIP.2trok16UEGQrckMAbed6PwHaEK?w=296&h=180&c=7&r=0&o=5&pid=1.7",
            width: 100,
            height: 30,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 1,
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          children: [
            DrawerHeader(
              padding: const EdgeInsets.all(0),
              child: UserAccountsDrawerHeader(
                accountName: Text(
                  "Alibehzad",
                  style: TextStyle(fontSize: 18),
                ),
                accountEmail: Text("test@mail.com"),
                arrowColor: Colors.white,
                margin: const EdgeInsets.all(0),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    "A",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                ),
              ),
            ),
            ListTile(
              title: Text("Profile"),
              leading: Icon(Icons.person_outline),
              onTap: () {},
            ),
            ListTile(
              title: Text("Orders"),
              leading: Icon(Icons.bookmark_border),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderPage(),
                    ));
              },
            ),
            ListTile(
              title: Text("Settings"),
              leading: Icon(Icons.settings_outlined),
              onTap: () {},
            ),
            ListTile(
              title: Text(
                "Logout",
                style: TextStyle(color: Colors.red),
              ),
              leading: Icon(
                Icons.exit_to_app_outlined,
                color: Colors.red,
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: FutureBuilder<List<SliderModel>>(
              future: sliderFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<SliderModel>? data = snapshot.data;
                  return Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        child: PageView.builder(
                          itemCount: data!.length,
                          allowImplicitScrolling: true,
                          controller: sliderController,
                          itemBuilder: (context, position) {
                            return sliderViewItem(data[position]);
                          },
                        ),
                        height: 200,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 10, left: 5, right: 5),
                        child: SmoothPageIndicator(
                          controller: sliderController,
                          count: data.length,
                          effect: const ExpandingDotsEffect(
                            dotHeight: 10,
                            dotWidth: 10,
                            spacing: 3,
                            dotColor: Colors.white,
                            activeDotColor: Colors.red,
                          ),
                          onDotClicked: (index) =>
                              sliderController.animateToPage(index,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.bounceOut),
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Container(
                    height: 200,
                    child: Center(
                      child: Text("No Data"),
                    ),
                  );
                } else {
                  return Container(
                    height: 200,
                    child: Center(child: circularProgressIndicator),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
            child: FutureBuilder<List<SpecialOfferProduct>>(
              future: specialOfferFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<SpecialOfferProduct>? data = snapshot.data;
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 300,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 300,
                              width: 150,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Image.network(
                                    "https://www.pngmart.com/files/9/Special-Offer-Transparent-PNG.png",
                                    width: 100,
                                    color: Colors.white,
                                  ),
                                  Image.network(
                                    "https://cdn3d.iconscout.com/3d/premium/thumb/product-discount-box-5168449-4323767.png",
                                    width: 100,
                                  ),
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        side: const BorderSide(
                                            color: Colors.white)),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Products(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      "More...",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: SizedBox(
                            child: ListView.builder(
                              itemCount: data!.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, position) {
                                return specialOfferView(data[position]);
                              },
                            ),
                            height: 300,
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Container(
                    height: 200,
                    child: Center(
                      child: Text("No Products"),
                    ),
                  );
                } else {
                  return Container(
                    height: 200,
                    child: Center(child: circularProgressIndicator),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 2.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Products(),
                              ),
                            );
                          },
                          child: Container(
                            height: 150,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                "https://assets.bucketlistly.blog/sites/5adf778b6eabcc00190b75b1/content_entry5b155bed5711a8176e9f9783/5dd4c25a400aef000ca937cc/files/azerbaijan-baku-travel-photo-20191119113425571-main-image.jpg",
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Center(
                                      child: circularProgressIndicator);
                                },
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 2.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Products(),
                              ),
                            );
                          },
                          child: Container(
                            height: 150,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                "https://th.bing.com/th/id/OIP.PhO9kTUSaCJgEiHKnA5IZwHaFc?rs=1&pid=ImgDetMain",
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Center(
                                      child: circularProgressIndicator);
                                },
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 2.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Products(),
                              ),
                            );
                          },
                          child: Container(
                            height: 150,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                "https://thumbs.dreamstime.com/b/souvenirs-sold-local-market-old-town-sheki-azerbaijan-clayware-karavan-saray-street-68939362.jpg",
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Center(
                                      child: circularProgressIndicator);
                                },
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 2.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Products(),
                              ),
                            );
                          },
                          child: Container(
                            height: 150,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                "https://thumbs.dreamstime.com/z/azerbaijan-baku-carpet-shop-old-city-capital-largest-as-well-as-largest-caspian-sea-64764595.jpg",
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Center(
                                      child: circularProgressIndicator);
                                },
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<List<SliderModel>> sendRequestSlider() async {
    List<SliderModel> model = [];
    var api = "https://picsum.photos/v2/list";
    var response = await Dio().get(api);

    var counter = 0;
    for (var item in response.data) {
      model.add(SliderModel(item["id"], item['download_url']));
      counter += 1;
      if (counter == 5) {
        break;
      }
    }
    return model;
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

  Padding sliderViewItem(SliderModel sliderModel) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          sliderModel.img,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            var circularProgressIndicator = CircularProgressIndicator(
              color: Colors.red,
              strokeWidth: 1.0,
            );
            return Center(child: circularProgressIndicator);
          },
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  SizedBox specialOfferView(SpecialOfferProduct specialOfferProduct) {
    return SizedBox(
      width: 180,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SingleProduct(specialOfferProduct)));
          },
          child: Card(
            color: Colors.white,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        specialOfferProduct.img,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          var circularProgressIndicator =
                              CircularProgressIndicator(
                            color: Colors.red,
                            strokeWidth: 1.0,
                          );
                          return Center(child: circularProgressIndicator);
                        },
                        fit: BoxFit.fill,
                        width: 150,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      specialOfferProduct.title,
                      overflow: TextOverflow.fade,
                      style: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  flex: 0,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          badges.Badge(
                            badgeContent: Text(
                              "0%",
                              style: TextStyle(fontSize: 11),
                            ),
                            badgeStyle:
                                badges.BadgeStyle(badgeColor: Colors.orange),
                            badgeAnimation: badges.BadgeAnimation.rotation(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Price: ${specialOfferProduct.off_price.toString()}\$",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MaterialButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SingleProduct(specialOfferProduct)));
                            },
                            child:
                                Text("Price: ${specialOfferProduct.price}\$"),
                            color: Colors.black,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
