import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop4you/providers/auth.dart';

import 'package:shop4you/widgets/buyerDetailRemarkTab.dart';
import 'package:shop4you/widgets/buyer_name_changing_tabl.dart';
import 'package:shop4you/widgets/flaotingButtonInBuyerDetail.dart';

import 'package:shop4you/widgets/product_showing_container.dart';

class BuyerDetailScreen extends StatefulWidget {
  static const routeName = "/buyer/detail";

  final dynamic buyer;

  BuyerDetailScreen({
    this.buyer,
  });

  @override
  _BuyerDetailScreenState createState() => _BuyerDetailScreenState();
}

class _BuyerDetailScreenState extends State<BuyerDetailScreen>
    with SingleTickerProviderStateMixin {
  final pageCon = PageController(
    initialPage: 1,
  );
  final _productScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Text(
            widget.buyer == null ? "買家載入中..." : widget.buyer["name"],
          ),
          onDoubleTap: () {
            _productScrollController.jumpTo(
              1.0,
            );
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
      body: PageView(
        controller: pageCon,
        children: <Widget>[
          BuyerDetailReamrkTab(
            buyer: widget.buyer,
          ),
          ProductShowingContainer(
            productScrollController: _productScrollController,
            initSearchingCon: {"uid": (widget.buyer ?? const {})["_id"]},
          ),
          BuyerNameChangingTab(
            buyer: widget.buyer,
          )
        ],
      ),
      floatingActionButton: FlaotingButtonInBuyerDetail(
        buyer: widget.buyer,
      ),
    );
  }
}
