import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop4you/providers/auth.dart';
import 'package:shop4you/providers/members.dart';
import 'package:shop4you/widgets/app_drawer.dart';
import 'package:shop4you/widgets/product_item.dart';
import 'package:shop4you/widgets/product_showing_container.dart';

class AllProductsScreen extends StatefulWidget {
  // Since we're using the searchingString and options; therefore, we need a stateful widget.
  static const routeName = "/products";
  const AllProductsScreen();

  @override
  _AllProductsScreenState createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  Future<void> _fetchingAllMembers() async {
    await Provider.of<Members>(context).fetchAndSetMembers();
  }

  final _productScrollController = ScrollController();

  void searchingFieldUpdate(SelectedMenu action, String inputString) {
    setState(() {
      if (action == SelectedMenu.SearchingBuyer) {
        searchingCon["uname"] = inputString;
      }

      if (action == SelectedMenu.SearchingProduct) {
        searchingCon["name"] = inputString;
      }
      _productScrollController.jumpTo(1);
    });
  }

  Map<String, dynamic> searchingCon = {
    "orderNum": null,
    "uname": null,
    "name": null,
    "bought": null,
    "paid": null,
    "received": null,
  };

  void searchingConUpdate(String key, dynamic val) {
    setState(() {
      print("current searching con is $searchingCon");

      searchingCon[key] = val;
      print("current searching con is $searchingCon");
    });
    print("current searching con is $searchingCon");
  }

  void searchingConClear() {
    setState(() {
      searchingCon.forEach((k, _) => searchingCon[k] = null);
      _productScrollController.jumpTo(1);
    });
  }

  // Create 3 options enum

  @override
  Widget build(BuildContext context) {
    print("rebuild all the screen");
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _fetchingAllMembers,
        child: ProductShowingContainer(
          productScrollController: _productScrollController,
        ),
      ),
      appBar: AppBar(
        title: GestureDetector(
          child: const Text("所有商品"),
          onDoubleTap: () {
            setState(() {
              _productScrollController.jumpTo(
                1.0,
              );
            });
          },
        ),
        actions: <Widget>[
          Center(
            child: Icon(
              Icons.local_florist,
              color: Colors.pink[100],
            ),
          ),
          Consumer<Auth>(
            builder: (context, auth, ch) {
              return Switch(
                value: auth.showSensitive,
                onChanged: (val) {
                  auth.setSensitive(val);
                },
              );
            },
          )
        ],
      ),
      drawer: AppDrawer(),
    );
  }
}
