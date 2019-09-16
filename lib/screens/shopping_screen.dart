import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop4you/providers/auth.dart';
import 'package:shop4you/providers/members.dart';
import 'package:shop4you/widgets/app_drawer.dart';
import 'package:shop4you/widgets/product_item.dart';
import 'package:shop4you/widgets/product_showing_container.dart';

class ShoppingScreen extends StatefulWidget {
  // Since we're using the searchingString and options; therefore, we need a stateful widget.
  static const routeName = "/shopping";
  const ShoppingScreen();

  @override
  _ShoppingScreenState createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
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
    "bought": false,
    "paid": null,
    "received": null,
  };

  void searchingConUpdate(String key, dynamic val) {
    setState(() {
      searchingCon[key] = val;
    });
  }

  void searchingConClear() {
    setState(() {
      searchingCon.forEach((k, _) => searchingCon[k] = null);
      _productScrollController.jumpTo(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("rebuild all the screen");
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _fetchingAllMembers,
        child: ProductShowingContainer(
          productScrollController: _productScrollController,
          initSearchingCon: searchingCon,
        ),
      ),
      appBar: AppBar(
        title: GestureDetector(
          child: const Text("購物清單"),
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
