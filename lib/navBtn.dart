import 'package:flutter/material.dart';
import 'package:shop_app_flutter/orders.dart';
import 'package:shop_app_flutter/products.dart';

class NavBtn extends StatelessWidget {
  const NavBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      elevation: 0,
      color: Colors.red,
      notchMargin: 5,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 2 - 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.person_outline),
                  color: Colors.white,
                  selectedIcon: Icon(Icons.person),
                  tooltip: "Profile",
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderPage(),
                        ));
                  },
                  icon: Icon(Icons.bookmark_border),
                  color: Colors.white,
                  selectedIcon: Icon(Icons.bookmark),
                  tooltip: "Orders",
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 2 - 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Products()));
                  },
                  icon: Icon(Icons.shopping_bag_outlined),
                  color: Colors.white,
                  selectedIcon: Icon(Icons.shopping_bag),
                  tooltip: "Shop",
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  tooltip: "Search",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
