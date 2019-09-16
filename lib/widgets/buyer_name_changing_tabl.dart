import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop4you/providers/members.dart';

class BuyerNameChangingTab extends StatefulWidget {
  final dynamic buyer;

  BuyerNameChangingTab({
    this.buyer,
  });

  @override
  _BuyerNameChangingTabState createState() => _BuyerNameChangingTabState();
}

class _BuyerNameChangingTabState extends State<BuyerNameChangingTab> {
  bool editing = false;

  @override
  void initState() {
    super.initState();
  }

  String nameContent;

  void updatingBuyerName(BuildContext ctx) {
    Provider.of<Members>(ctx).updateMember(widget.buyer["_id"], {
      "name": nameContent,
    });

    setState(() {
      editing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    nameContent = widget.buyer["name"];
    var mediaQueryData = MediaQuery.of(context);

    return widget.buyer == null
        ? const Center(
            child: const CircularProgressIndicator(),
          )
        : !editing
            ? Container(
                margin: EdgeInsets.only(top: mediaQueryData.size.height * 0.05),
                alignment: Alignment.topCenter,
                child: Card(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: mediaQueryData.size.width * 0.8,
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            widget.buyer["name"],
                          ),
                        ),
                        FlatButton(
                          child: const Text("Edit"),
                          onPressed: () {
                            setState(() {
                              editing = true;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ),
              )
            : Column(
                children: <Widget>[
                  Container(
                    margin:
                        EdgeInsets.only(top: mediaQueryData.size.height * 0.01),
                    alignment: Alignment.topCenter,
                    child: Card(
                      child: Container(
                        width: mediaQueryData.size.width * 0.8,
                        height: mediaQueryData.size.height * 0.37,
                        padding: const EdgeInsets.all(20),
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                initialValue: widget.buyer["name"],
                                onChanged: (v) {
                                  nameContent = v;
                                },
                                decoration: const InputDecoration(
                                  labelText: "名稱",
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  FlatButton(
                                    onPressed: () {
                                      setState(() {
                                        editing = false;
                                      });
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  FlatButton(
                                    onPressed: () => updatingBuyerName(context),
                                    child: const Text("Submit"),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
  }
}
