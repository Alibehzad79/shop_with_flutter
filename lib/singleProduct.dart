import 'package:flutter/material.dart';
import 'package:shop_app_flutter/model/commentsModel.dart';
import 'package:shop_app_flutter/model/specialOfferProducts.dart';
import 'package:shop_app_flutter/products.dart';
import 'package:dio/dio.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class SingleProduct extends StatefulWidget {
  SpecialOfferProduct specialOfferProduct;
  SingleProduct(this.specialOfferProduct);

  @override
  State<SingleProduct> createState() => _SingleProductState();
}

class _SingleProductState extends State<SingleProduct> {
  late Future<List<CommentModel>> commentFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    commentFuture = sendRequestComment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Product",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
          ),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView(
                    children: [
                      Card(
                        elevation: 0,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(widget.specialOfferProduct.img,
                                height: 300, fit: BoxFit.fill, loadingBuilder:
                                    (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Colors.red,
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                      Card(
                        elevation: 0,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              widget.specialOfferProduct.title.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Card(
                        elevation: 0,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Price: " +
                                widget.specialOfferProduct.price.toString() +
                                "\$",
                          ),
                        ),
                      ),
                      Card(
                        elevation: 0,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Description:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(widget.specialOfferProduct.description
                                  .toString()),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => Products())));
                        },
                        child: Card(
                          elevation: 0,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    "Category:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  widget.specialOfferProduct.category
                                      .toString(),
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        elevation: 0,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(
                                  "Rating:",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 1.0),
                                child: RatingBarIndicator(
                                  rating: widget.specialOfferProduct.rating,
                                  itemBuilder: (context, index) {
                                    return Icon(
                                      Icons.star,
                                      color: Colors.amber.shade900,
                                    );
                                  },
                                  itemCount:
                                      widget.specialOfferProduct.rating.round(),
                                  direction: Axis.horizontal,
                                  itemSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        elevation: 0,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Comments: ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 0),
                                child: SizedBox(
                                  height: 300,
                                  child: FutureBuilder<List<CommentModel>>(
                                    future: commentFuture,
                                    builder: ((context, snapshot) {
                                      if (snapshot.hasData) {
                                        List<CommentModel>? data =
                                            snapshot.data;
                                        return ListView.builder(
                                          physics:
                                              AlwaysScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: data!.length,
                                          itemBuilder: (context, index) =>
                                              commentListView(data[index]),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Center(
                                          child: Text("No Comments!"),
                                        );
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.red,
                                            strokeWidth: 1,
                                          ),
                                        );
                                      }
                                    }),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        elevation: 0,
                        color: Colors.white,
                        child: Container(
                          width: MediaQuery.of(context).size.width - 20,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    "Send a new Comment",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 10),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    label: Text("Full Name"),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 10),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    label: Text("Email"),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 10),
                                child: TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 4,
                                  decoration: InputDecoration(
                                    label: Text("Comment"),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 8, bottom: 10),
                                child: Container(
                                  width: MediaQuery.of(context).size.width - 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange),
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Row(
                                            children: [
                                              Text(
                                                "Received Successfuly",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 2.0),
                                                child: Icon(
                                                  Icons.check_circle_outline,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          backgroundColor: Colors.green,
                                          duration:
                                              Duration(milliseconds: 1500),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Send",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width - 30,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Text(
                                "Added to Order",
                                style: TextStyle(color: Colors.white),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 2.0),
                                child: Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                          backgroundColor: Colors.green,
                          duration: Duration(milliseconds: 1500),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        Text(
                          "Add to Order",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 10,
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<List<CommentModel>> sendRequestComment() async {
    List<CommentModel> model = [];
    SpecialOfferProduct specialOfferProduct;
    var api =
        "https://dummyjson.com/comments/post/${widget.specialOfferProduct.id}";
    var response = await Dio().get(api);
    var respons_data = response.data["comments"];
    for (var item in respons_data) {
      model.add(
        CommentModel(item["id"], item["body"], item["user"]["username"]),
      );
    }
    return model;
  }

  Align commentListView(CommentModel commentModel) {
    return Align(
      alignment: Alignment.topLeft,
      child: Card(
        elevation: 0.5,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: MediaQuery.of(context).size.width - 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 2.0),
                      child: Icon(
                        Icons.person_outline,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      commentModel.user.toString(),
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 2.0),
                      child: Icon(
                        Icons.comment,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      commentModel.body.toString(),
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
