import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop4you/providers/members.dart';
import 'package:shop4you/widgets/product_detail_card.dart';
import 'package:shop4you/widgets/product_item.dart';

class ConditionProductList extends StatefulWidget {
  final ScrollController productScrollController;
  final bool showBuyerName;
  final Function searchingFieldUpdate;
  final Map<String, dynamic> searchingCon;
  final bool usingUID;

  // get allProduct & showDetail & conditions byitself.

  ConditionProductList({
    this.productScrollController,
    this.showBuyerName = true,
    this.searchingFieldUpdate,
    this.searchingCon,
  }) : usingUID = searchingCon != null && searchingCon["uid"] != null;

  @override
  _ConditionProductListState createState() => _ConditionProductListState();
}

class _ConditionProductListState extends State<ConditionProductList>
    with AutomaticKeepAliveClientMixin {
  bool isInit = false;
  bool showDetail;

  @override
  bool get wantKeepAlive => true;

  Widget whenNotInit(BuildContext ctx) {
    print("When not init Called");
    Provider.of<Members>(ctx).fetchAndSetMembers();
    return Center(
      child: const CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> showingProduct = Provider.of<Members>(context)
        .getShowingResultBySearchingCon(widget.searchingCon);
    return showingProduct == null
        ? whenNotInit(context)
        : ListView.builder(
            controller: widget.productScrollController,
            itemCount: showingProduct.length + 2,
            itemBuilder: (ctx, idx) {
              if (idx == 0) {
                return ProductDetailCard(
                  products: showingProduct,
                );
              }

              if (idx == showingProduct.length + 1) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2 > 50
                      ? MediaQuery.of(context).size.height * 0.2
                      : 50,
                );
              }

              return Column(
                children: <Widget>[
                  ProductItem(
                    product: showingProduct[idx - 1],
                    showBuyerName: widget.showBuyerName,
                    searchingFieldUpdate: widget.searchingFieldUpdate,
                  ),
                  const Divider(),
                ],
              );
            },
          );
  }
}
