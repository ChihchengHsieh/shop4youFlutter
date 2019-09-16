import 'package:flutter/material.dart';
import 'package:shop4you/screens/all_products_screen.dart';
import 'package:shop4you/screens/delivery_screen.dart';
import 'package:shop4you/screens/shopping_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            AppBar(
              title: const Text("Shop4you.AU"),
              automaticallyImplyLeading: false, // What's this
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text("所有買家"),
              onTap: () {
                Navigator.of(context).pushReplacementNamed("/");
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text("所有商品"),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(AllProductsScreen.routeName);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text("購物清單"),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(ShoppingScreen.routeName);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.airport_shuttle),
              title: const Text("未送商品"),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(DeliveryScreen.routeName);
              },
            )
          ],
        ),
      ),
    );
  }
}
