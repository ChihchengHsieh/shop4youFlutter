import 'package:flutter/material.dart';
import 'package:shop4you/widgets/new_product_card.dart';

class ProductFormFullScreenDialog extends StatelessWidget {
  final dynamic product;
  final String buyerId;
  final String uname;

  ProductFormFullScreenDialog({this.product, this.buyerId, this.uname});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(uname ?? (product == null ? "商品" : product["uname"])),
        ),
        body: NewProductCard(
          product: product,
          buyerId: buyerId,
        ));
  }
}
