import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop4you/providers/auth.dart';
import 'package:shop4you/providers/members.dart';
import 'package:shop4you/screens/buyer_detail_screen.dart';
import 'package:shop4you/widgets/product_form_full_screen_dialog.dart';

enum SelectedMenu {
  SearchingProduct,
  SearchingBuyer,
}

class ProductItem extends StatefulWidget {
  final dynamic product;
  final bool showBuyerName;
  final Function searchingFieldUpdate;
  ProductItem({
    this.product,
    this.showBuyerName = true,
    this.searchingFieldUpdate,
  }) : super(key: ValueKey(product["_id"]));

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  String getProfit(double buyPriceAUD, double sellPriceTWD, double q) {
    const rate = 22;

    var profit = (sellPriceTWD ?? 0) - ((buyPriceAUD ?? 0) * rate);
    profit *= (q ?? 0);
    return profit.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    bool showDetail =
        Provider.of<Auth>(context).showSensitive; // use consumer for this
    var mediaQueryData = MediaQuery.of(context);
    return Dismissible(
      key: ValueKey(widget.product["_id"]),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Column(
                    children: <Widget>[
                      Text("你確定要刪除?"),
                      Text("${widget.product["uname"]} 的"),
                      Text("${widget.product["name"]}"),
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("否"),
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                    ),
                    FlatButton(
                      child: Text("是"),
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      },
                    )
                  ],
                ));
      },
      onDismissed: (direction) {
        Provider.of<Members>(context).deleteProductForMember(
            widget.product["uid"], widget.product["_id"]);
      },
      child: GestureDetector(
        onLongPressStart: widget.searchingFieldUpdate != null
            ? (detail) async {
                final value = await showMenu(
                  position: RelativeRect.fromLTRB(
                    detail.globalPosition.dx,
                    detail.globalPosition.dy,
                    detail.globalPosition.dx,
                    detail.globalPosition.dy,
                  ),
                  context: context,
                  items: [
                    if (!widget.showBuyerName)
                      PopupMenuItem(
                        child: const Text(
                          "搜尋買家",
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        value: SelectedMenu.SearchingBuyer,
                      ),
                    PopupMenuItem(
                      child: const Text(
                        "搜尋商品",
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      value: SelectedMenu.SearchingProduct,
                    ),
                  ],
                );
                widget.searchingFieldUpdate(
                    value,
                    value == SelectedMenu.SearchingBuyer
                        ? widget.product["uname"]
                        : widget.product["name"]);
              }
            : null,
        child: Card(
          margin: const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 4,
          ),
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: ListTile(
              title: Consumer<Auth>(
                builder: (context, auth, child) {
                  return Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(right: 2, top: 2),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 2,
                            ),
                            height: mediaQueryData.size.height * 0.08,
                            width: mediaQueryData.size.width * 0.04,
                            child: FittedBox(
                              child: GestureDetector(
                                child: Text(
                                  (widget.product["orderNum"] == null ||
                                          widget.product["orderNum"]
                                              .toString()
                                              .trim()
                                              .isEmpty)
                                      ? "?"
                                      : widget.product["orderNum"],
                                ),
                              ),
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              if (widget.showBuyerName)
                                Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 2,
                                  ),
                                  height: mediaQueryData.size.height * 0.04,
                                  width: mediaQueryData.size.width * 0.35,
                                  child: Center(
                                    child: FlatButton(
                                      child: Text(
                                        (widget.product["uname"] == null ||
                                                widget.product["uname"]
                                                    .toString()
                                                    .trim()
                                                    .isEmpty)
                                            ? "未輸入"
                                            : widget.product["uname"],
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pushNamed(
                                          BuyerDetailScreen.routeName,
                                          arguments: {
                                            "buyerId": widget.product["uid"],
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                ),
                                height: mediaQueryData.size.height *
                                    (widget.showBuyerName ? 0.04 : 0.08),
                                width: mediaQueryData.size.width * 0.35,
                                child: Center(
                                  child: FlatButton(
                                    child: Text(
                                      (widget.product["name"] == null ||
                                              widget.product["name"]
                                                  .toString()
                                                  .trim()
                                                  .isEmpty)
                                          ? "未輸入"
                                          : widget.product["name"],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProductFormFullScreenDialog(
                                              product: widget.product,
                                            ),
                                            fullscreenDialog: true,
                                          ));
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                right: mediaQueryData.size.width * 0.04),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 2,
                            ),
                            height: mediaQueryData.size.height * 0.08,
                            width: mediaQueryData.size.width * 0.1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                if (!showDetail)
                                  FittedBox(
                                    child: Text(
                                      (widget.product["sellPriceTWD"] == null ||
                                              widget.product["sellPriceTWD"]
                                                  .toString()
                                                  .trim()
                                                  .isEmpty)
                                          ? "未輸入"
                                          : "\$${widget.product["sellPriceTWD"]}",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                FittedBox(
                                  child: Text(
                                    (widget.product["quantity"] == null ||
                                            widget.product["quantity"]
                                                .toString()
                                                .trim()
                                                .isEmpty)
                                        ? "未輸入"
                                        : "${widget.product["quantity"]}個",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 6),
                            height: mediaQueryData.orientation ==
                                    Orientation.portrait
                                ? mediaQueryData.size.height * 0.04
                                : mediaQueryData.size.width * 0.04,
                            width: mediaQueryData.orientation ==
                                    Orientation.portrait
                                ? mediaQueryData.size.height * 0.04
                                : mediaQueryData.size.width * 0.04,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(40)),
                              color: widget.product["bought"]
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).primaryColorLight,
                            ),
                            child: IconButton(
                              onPressed: () {
                                Provider.of<Members>(context)
                                    .updateProductToMember(
                                        widget.product["uid"],
                                        widget.product["_id"],
                                        {"bought": !widget.product["bought"]});
                              },
                              icon: const Icon(
                                Icons.shopping_cart,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 6),
                            width: mediaQueryData.orientation ==
                                    Orientation.portrait
                                ? mediaQueryData.size.height * 0.04
                                : mediaQueryData.size.width * 0.04,
                            height: mediaQueryData.orientation ==
                                    Orientation.portrait
                                ? mediaQueryData.size.height * 0.04
                                : mediaQueryData.size.width * 0.04,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(40)),
                              color: widget.product["paid"]
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).primaryColorLight,
                            ),
                            child: IconButton(
                              onPressed: () {
                                Provider.of<Members>(context)
                                    .updateProductToMember(
                                        widget.product["uid"],
                                        widget.product["_id"],
                                        {"paid": !widget.product["paid"]});
                              },
                              icon: const Icon(
                                Icons.payment,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 6),
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(40)),
                              color: widget.product["received"]
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).primaryColorLight,
                            ),
                            width: mediaQueryData.orientation ==
                                    Orientation.portrait
                                ? mediaQueryData.size.height * 0.04
                                : mediaQueryData.size.width * 0.04,
                            height: mediaQueryData.orientation ==
                                    Orientation.portrait
                                ? mediaQueryData.size.height * 0.04
                                : mediaQueryData.size.width * 0.04,
                            child: IconButton(
                              onPressed: () {
                                Provider.of<Members>(context)
                                    .updateProductToMember(
                                        widget.product["uid"],
                                        widget.product["_id"], {
                                  "received": !widget.product["received"]
                                });
                              },
                              icon: const Icon(
                                Icons.airport_shuttle,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (showDetail)
                        Row(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 2,
                              ),
                              height: mediaQueryData.size.height * 0.04,
                              width: mediaQueryData.size.width * 0.17,
                              child: Center(
                                child: Text(
                                  (widget.product["buyPriceAUD"] == null ||
                                          widget.product["buyPriceAUD"]
                                              .toString()
                                              .trim()
                                              .isEmpty)
                                      ? "未輸入"
                                      : "\$${widget.product["buyPriceAUD"]}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 2,
                              ),
                              height: mediaQueryData.size.height * 0.04,
                              width: mediaQueryData.size.width * 0.17,
                              child: Center(
                                child: Text(
                                  (widget.product["buyPriceAUD"] == null ||
                                          widget.product["buyPriceAUD"]
                                              .toString()
                                              .trim()
                                              .isEmpty)
                                      ? "未輸入"
                                      : "\$${widget.product["sellPriceTWD"]}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 2,
                              ),
                              height: mediaQueryData.size.height * 0.04,
                              width: mediaQueryData.size.width * 0.17,
                              child: Center(
                                child: Text(
                                  "\$${getProfit(
                                    double.tryParse(
                                        widget.product["buyPriceAUD"]),
                                    double.tryParse(
                                        widget.product["sellPriceTWD"]),
                                    double.tryParse(widget.product["quantity"]),
                                  )}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              padding: EdgeInsets.symmetric(
                                horizontal: 2,
                              ),
                              height: mediaQueryData.size.height * 0.04,
                              width: mediaQueryData.size.width * 0.2,
                              child: Center(
                                child: Text(
                                  (widget.product["seller"] == null ||
                                          widget.product["seller"]
                                              .toString()
                                              .trim()
                                              .isEmpty)
                                      ? "未輸入"
                                      : "${widget.product["seller"]}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        )
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
