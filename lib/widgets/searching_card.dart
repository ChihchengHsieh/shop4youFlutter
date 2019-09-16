import 'package:flutter/material.dart';
import 'package:shop4you/providers/members.dart';

class SearchingCard extends StatefulWidget {
  final Function searchingConUpdate;
  final Function searchingConClear;
  final Map<String, dynamic> searchingCon;

  SearchingCard(
    this.searchingConUpdate,
    this.searchingConClear,
    this.searchingCon,
  );

  @override
  _SearchingCardState createState() => _SearchingCardState();
}

class _SearchingCardState extends State<SearchingCard> {
  bool _expanded = false;
  bool forCertainUser = false;

  final orderCon = TextEditingController();
  final buyerCon = TextEditingController();
  final productCon = TextEditingController();

  @override
  void initState() {
    super.initState();
    forCertainUser =
        widget.searchingCon != null && widget.searchingCon["uid"] != null;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 4,
      ),
      child: Column(
        children: <Widget>[
          GestureDetector(
            child: ListTile(
              title: Text("搜尋..."),
              trailing: RaisedButton(
                onPressed: () {
                  widget.searchingConClear();
                  orderCon.clear();
                  buyerCon.clear();
                  productCon.clear();
                },
                child: const Text("清除"),
              ),
            ),
            onTap: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn,
            height: _expanded
                ? MediaQuery.of(context).orientation == Orientation.portrait
                    ? (MediaQuery.of(context).size.height *
                        (forCertainUser ? 0.15 : 0.22))
                    : (forCertainUser ? 130 : 200)
                : 0,
            margin: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 2,
            ),
            child: ListView(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: TextField(
                          controller: orderCon,
                          decoration: const InputDecoration(labelText: "單"),
                          onChanged: (val) {
                            widget.searchingConUpdate("orderNum", val);
                          },
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 5,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: TextField(
                          controller: productCon,
                          decoration: const InputDecoration(labelText: "商品"),
                          onChanged: (val) {
                            widget.searchingConUpdate("name", val);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                if (!forCertainUser)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: TextField(
                      controller: buyerCon,
                      decoration: const InputDecoration(labelText: "買家"),
                      onChanged: (val) {
                        widget.searchingConUpdate("uname", val);
                      },
                    ),
                  ),
                Row(
                  children: <Widget>[
                    Flexible(
                      fit: FlexFit.tight,
                      child: Container(
                        padding:const EdgeInsets.symmetric(horizontal: 5),
                        child: DropdownButton(
                          value: () {
                            if (widget.searchingCon != null &&
                                widget.searchingCon["bought"] != null) {
                              return widget.searchingCon["bought"] == true
                                  ? BuyOption.Already
                                  : BuyOption.NotYet;
                            }
                            return BuyOption.Empty;
                          }(),
                          onChanged: (val) {
                            widget.searchingConUpdate("bought", val);
                          },
                          items: [
                            DropdownMenuItem<BuyOption>(
                              value: BuyOption.Empty,
                              child: const Text("全部"),
                            ),
                            DropdownMenuItem<BuyOption>(
                              value: BuyOption.Already,
                              child: const Text("已買"),
                            ),
                            DropdownMenuItem<BuyOption>(
                              value: BuyOption.NotYet,
                              child: const Text("未買"),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: DropdownButton(
                          value: () {
                            if (widget.searchingCon != null &&
                                widget.searchingCon["paid"] != null) {
                              return widget.searchingCon["paid"] == true
                                  ? PayOption.Already
                                  : PayOption.NotYet;
                            }
                            return PayOption.Empty;
                          }(),
                          onChanged: (val) {
                            widget.searchingConUpdate("paid", val);
                          },
                          items: [
                            DropdownMenuItem<PayOption>(
                              value: PayOption.Empty,
                              child: const Text("全部"),
                            ),
                            DropdownMenuItem<PayOption>(
                              value: PayOption.Already,
                              child: const Text("已付"),
                            ),
                            DropdownMenuItem<PayOption>(
                              value: PayOption.NotYet,
                              child: const Text("未付"),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: DropdownButton(
                          value: () {
                            if (widget.searchingCon != null &&
                                widget.searchingCon["received"] != null) {
                              return widget.searchingCon["received"] == true
                                  ? ReceiveOption.Already
                                  : ReceiveOption.NotYet;
                            }
                            return ReceiveOption.Empty;
                          }(),
                          onChanged: (val) {
                            widget.searchingConUpdate("received", val);
                          },
                          items: [
                            DropdownMenuItem<ReceiveOption>(
                              value: ReceiveOption.Empty,
                              child: const Text("全部"),
                            ),
                            DropdownMenuItem<ReceiveOption>(
                              value: ReceiveOption.Already,
                              child: const Text("已收"),
                            ),
                            DropdownMenuItem<ReceiveOption>(
                              value: ReceiveOption.NotYet,
                              child: const Text("未收"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
