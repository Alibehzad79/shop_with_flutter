import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shop_app_flutter/model/specialOfferProducts.dart';
import 'package:shop_app_flutter/singleProduct.dart';
import 'model/orderModel.dart';
import 'package:input_quantity/input_quantity.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late Future<List<OrderModel>> orderFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    orderFuture = sendRequestOrderList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text("Order"),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        centerTitle: true,
        backgroundColor: Colors.red,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
        ),
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Scrollbar(
                child: Container(
                  height: MediaQuery.of(context).size.height - 150,
                  child: FutureBuilder<List<OrderModel>>(
                    future: orderFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<OrderModel>? data = snapshot.data;
                        return ListView.builder(
                          itemCount: data!.length,
                          itemBuilder: (context, index) =>
                              orderItemList(data[index]),
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text("No Order"));
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
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width - 10,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      "checkout",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<List<OrderModel>> sendRequestOrderList() async {
    List<OrderModel> model = [];
    var api = "https://dummyjson.com/carts/1";
    var response = await Dio().get(api);
    var products = response.data["products"];
    for (var item in products) {
      model.add(OrderModel(item["id"], item["title"], item["price"],
          item["thumbnail"], item["quantity"]));
    }
    return model;
  }

  Padding orderItemList(OrderModel orderModel) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(13)),
                    child: Image.network(
                      orderModel.img,
                      width: 80,
                      height: 60,
                      fit: BoxFit.fill,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.red,
                            strokeWidth: 1,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    orderModel.title.toString(),
                    style: TextStyle(fontSize: 10),
                    overflow: TextOverflow.fade,
                  ),
                ),
                InputQty(
                  maxVal: 100,
                  initVal: orderModel.quantity,
                  minVal: 1,
                  steps: 1,
                  onQtyChanged: (val) {
                    print(val);
                  },
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
