import 'package:flutter/material.dart';
import 'package:shop4you/widgets/product_form_full_screen_dialog.dart';

class FlaotingButtonInBuyerDetail extends StatelessWidget {
  final dynamic buyer;

  FlaotingButtonInBuyerDetail({
    this.buyer,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                final di = ProductFormFullScreenDialog(
                  buyerId: buyer["_id"],
                  uname: buyer == null ? "買家" : buyer["name"],
                );
                return di;
              },
              fullscreenDialog: true,
            ));
      },
    );
  }
}
