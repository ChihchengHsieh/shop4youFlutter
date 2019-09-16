import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop4you/providers/members.dart';
import 'package:shop4you/screens/buyer_detail_screen.dart';

class BuyerItem extends StatefulWidget {
  final dynamic _buyer;

  BuyerItem(this._buyer) : super(key: ValueKey(_buyer["_id"]));

  @override
  _BuyerItemState createState() => _BuyerItemState();
}

class _BuyerItemState extends State<BuyerItem> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget._buyer["_id"]),
      background: Container(
        color: Theme.of(context).errorColor,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("刪除 ${widget._buyer["name"]}?"),
            actions: <Widget>[
              FlatButton(
                child: const Text("否"),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
              FlatButton(
                child: const Text("是"),
                onPressed: () async {
                  Navigator.of(ctx).pop(true);
                },
              )
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<Members>(context).deleteMember(widget._buyer["_id"]);
      },
      child: GestureDetector(
        child: Card(
          margin: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 4,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ListTile(
              title: Center(child: Text(widget._buyer["name"])),
            ),
          ),
        ),
        onTap: () {
          Navigator.of(context)
              .pushNamed(BuyerDetailScreen.routeName, arguments: {
            "buyer": widget._buyer,
          });
        },
      ),
    );
  }
}
