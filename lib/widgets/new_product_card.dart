import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop4you/providers/members.dart';

enum ProductFormMode {
  Editing,
  Adding,
}

class NewProductCard extends StatefulWidget {
  final String buyerId;
  final dynamic product;
  ProductFormMode mode;
  Map<String, dynamic> initProduct;

  // Passing _buyerId for adding, product for editing

  NewProductCard({this.buyerId, this.product}) {
    // One of them has to pass
    if (this.product == null) {
      mode = ProductFormMode.Adding;
    } else if (this.buyerId == null) {
      mode = ProductFormMode.Editing;
    }

    if (mode == ProductFormMode.Editing && product != null) {
      initProduct = {
        "name": product["name"] ?? "",
        "quantity": int.tryParse(product["quantity"]) ?? 0,
        "buyPriceAUD": double.tryParse(product["buyPriceAUD"]) ?? 0,
        "sellPriceTWD": double.tryParse(product["sellPriceTWD"]) ?? 0,
        "seller": product["seller"] ?? "",
        "orderNum": product["orderNum"] ?? "",
        "paid": product["paid"],
        "bought": product["bought"],
        "received": product["received"],
      };
    } else {
      initProduct = {
        "name": "",
        "quantity": "",
        "buyPriceAUD": "",
        "sellPriceTWD": "",
        "seller": "",
        "orderNum": "",
        "paid": false,
        "bought": false,
        "received": false,
      };
    }
  }

  @override
  _NewProductCardState createState() => _NewProductCardState();
}

class _NewProductCardState extends State<NewProductCard> {
  final _form = GlobalKey<FormState>();
  final _prodcutNameFN = FocusNode();
  final _quaFN = FocusNode();
  final _sellerFN = FocusNode();
  final _buyAUDFN = FocusNode();
  final _sellTWDFN = FocusNode();
  void updateProduct(BuildContext ctx) async {
    _form.currentState.save();

    await Provider.of<Members>(ctx).updateProductToMember(
        widget.product["uid"], widget.product["_id"], widget.initProduct);
  }

  void addProduct(BuildContext ctx) async {
    _form.currentState.save();

    await Provider.of<Members>(ctx)
        .addProductToMember(widget.buyerId, widget.initProduct);
  }

  void submiteController(BuildContext ctx) {
    if (!_form.currentState.validate()) {
      return;
    }
    print("valid is ${_form.currentState.validate()}");

    if (widget.mode == ProductFormMode.Adding) {
      addProduct(ctx);
    } else if (widget.mode == ProductFormMode.Editing) {
      updateProduct(ctx);
    } else {
      print("Doesn't support this mode");
    }
    Navigator.of(ctx).pop();
  }

  @override
  build(BuildContext context) {
    print("The build is called");
    return Form(
        key: _form,
        child: ListView(
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: widget.initProduct["orderNum"]?.toString(),
                      decoration: const InputDecoration(
                        labelText: "單",
                        border: const OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_prodcutNameFN);
                      },
                      onSaved: (v) {
                        widget.initProduct["orderNum"] = v;
                      },
                      validator: (v) {
                        if (v.isEmpty) {
                          return "輸入";
                        }

                        if (int.tryParse(v) == null) {
                          return "無效";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Flexible(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: widget.initProduct["name"]?.toString(),
                      decoration: const InputDecoration(
                        labelText: "商品",
                        border: const OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                      focusNode: _prodcutNameFN,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_quaFN);
                      },
                      onSaved: (v) {
                        widget.initProduct["name"] = v;
                      },
                      validator: (v) {
                        if (v.isEmpty) {
                          return "請輸入商品";
                        }

                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: widget.initProduct["quantity"]?.toString(),
                      decoration: const InputDecoration(
                        labelText: "數量",
                        border: const OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                      focusNode: _quaFN,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_sellerFN);
                      },
                      onSaved: (v) {
                        widget.initProduct["quantity"] = v;
                      },
                      validator: (v) {
                        if (v.isEmpty) {
                          return "輸入";
                        }

                        if (int.tryParse(v) == null) {
                          return "無效";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Flexible(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: widget.initProduct["seller"]?.toString(),
                      decoration: const InputDecoration(
                        labelText: "廠商",
                        border: const OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                      focusNode: _sellerFN,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_buyAUDFN);
                      },
                      onSaved: (v) {
                        widget.initProduct["seller"] = v;
                      },
                      validator: (v) {
                        if (v.isEmpty) {
                          return "請輸入廠商";
                        }

                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue:
                          widget.initProduct["buyPriceAUD"]?.toString(),
                      decoration: const InputDecoration(
                        labelText: "買\$AUD",
                        border: const OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                      focusNode: _buyAUDFN,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_sellTWDFN);
                      },
                      onSaved: (v) {
                        widget.initProduct["buyPriceAUD"] = v;
                      },
                      validator: (v) {
                        if (v.isEmpty) {
                          return "請輸入進價";
                        }

                        if (double.tryParse(v) == null) {
                          return "請輸入有效數字";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue:
                          widget.initProduct["sellPriceTWD"]?.toString(),
                      decoration: const InputDecoration(
                        labelText: "賣\$TWD",
                        border: const OutlineInputBorder(),
                      ),
                      focusNode: _sellTWDFN,
                      onSaved: (v) {
                        widget.initProduct["sellPriceTWD"] = v;
                      },
                      onFieldSubmitted: (_) {
                        submiteController(context);
                      },
                      validator: (v) {
                        if (v.isEmpty) {
                          return "請輸入售價";
                        }

                        if (double.tryParse(v) == null) {
                          return "請輸入有效數字";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
            ListTile(
              trailing: FloatingActionButton(
                onPressed: () {
                  submiteController(context);
                },
                child: const Icon(Icons.send),
              ),
            )
          ],
        ));
  }
}
