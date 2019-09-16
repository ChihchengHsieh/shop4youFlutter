import 'package:flutter/material.dart';
import 'package:shop4you/widgets/condition_product_list.dart';
import 'package:shop4you/widgets/product_item.dart';
import 'package:shop4you/widgets/searching_card.dart';

class ProductShowingContainer extends StatefulWidget {
  final ScrollController productScrollController;
  final Map<String, dynamic> initSearchingCon;

  ProductShowingContainer({
    this.productScrollController,
    this.initSearchingCon,
  });

  @override
  _ProductShowingContainerState createState() =>
      _ProductShowingContainerState();
}

class _ProductShowingContainerState extends State<ProductShowingContainer> {
  Map<String, dynamic> searchingCon = {
    "orderNum": null,
    "uname": null,
    "name": null,
    "bought": null,
    "paid": null,
    "received": null,
  };
  @override
  void initState() {
    super.initState();

    widget.initSearchingCon?.forEach((k, v) {
      searchingCon[k] = v;
    });
  }

  void searchingFieldUpdate(SelectedMenu action, String inputString) {
    setState(() {
      if (action == SelectedMenu.SearchingBuyer) {
        searchingCon["uname"] = inputString;
      }

      if (action == SelectedMenu.SearchingProduct) {
        searchingCon["name"] = inputString;
      }
      widget.productScrollController.jumpTo(1);
    });
  }

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
      searchingCon["orderNum"] = null;
      searchingCon["uname"] = null;
      searchingCon["name"] = null;
      searchingCon["bought"] = null;
      searchingCon["paid"] = null;
      searchingCon["received"] = null;
      widget.productScrollController.jumpTo(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.89 ,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          SearchingCard(
            searchingConUpdate,
            searchingConClear,
            searchingCon,
          ),
          Expanded(
            child: ConditionProductList(
              searchingCon: searchingCon,
              productScrollController: widget.productScrollController,
              searchingFieldUpdate: searchingFieldUpdate,
              showBuyerName:
                  !(searchingCon != null && searchingCon["uid"] != null),
            ),
          ),
        ],
      ),
    );
  }
}
