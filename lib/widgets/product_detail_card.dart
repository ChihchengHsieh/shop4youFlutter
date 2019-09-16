import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop4you/providers/auth.dart';

class ProductDetailCard extends StatelessWidget {
  final List<dynamic> products;

  double getProfit(double buyPriceAUD, double sellPriceTWD, double q) {
    const rate = 22;

    var profit = (sellPriceTWD ?? 0) - ((buyPriceAUD ?? 0) * rate);
    profit *= (q ?? 0);
    return profit;
  }

  Map<String, double> getProfitQuantityUnpaid() {
    var qua = 0.0;
    var profit = 0.0;
    var unpaid = 0.0;
    products.forEach((p) {
      qua += double.tryParse(p["quantity"]) ?? 0;
      profit += getProfit(
        double.tryParse(p["buyPriceAUD"]),
        double.tryParse(p["sellPriceTWD"]),
        double.tryParse(p["quantity"]),
      );
      if (!p["paid"]) {
        unpaid += double.tryParse(p["sellPriceTWD"]) ?? 0;
      }
    });

    return {
      "profit": profit,
      "quantity": qua,
      "unpaid": unpaid,
    };
  }

  ProductDetailCard({this.products});

  @override
  Widget build(BuildContext context) {
    final data = getProfitQuantityUnpaid();
    bool showDetail = Provider.of<Auth>(context).showSensitive;
    return Container(
      padding: const EdgeInsets.all(8),
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              if (showDetail)
                Text("利潤: \$${data["profit"].toStringAsFixed(2)}"),
              if (showDetail)
                Text("數量: ${data["quantity"].toStringAsFixed(0)}"),
              Text("未付: \$${data["unpaid"].toStringAsFixed(2)}"),
            ],
          ),
        ),
      ),
    );
  }
}
