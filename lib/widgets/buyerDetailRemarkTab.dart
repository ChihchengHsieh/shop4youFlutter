import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop4you/providers/members.dart';

class BuyerDetailReamrkTab extends StatefulWidget {
  final dynamic buyer;

  BuyerDetailReamrkTab({
    this.buyer,
  });

  @override
  _BuyerDetailReamrkTabState createState() => _BuyerDetailReamrkTabState();
}

class _BuyerDetailReamrkTabState extends State<BuyerDetailReamrkTab> {
  bool remarkEditing = false;

  @override
  void initState() {
    super.initState();
  }

  String remarkContent;

  void updatingBuyerRemark(BuildContext ctx) {
    Provider.of<Members>(ctx).updateMember(widget.buyer["_id"], {
      "remark": remarkContent,
    });

    setState(() {
      remarkEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    remarkContent = widget.buyer["remark"];
    var mediaQueryData = MediaQuery.of(context);

    return widget.buyer == null
        ? const Center(
            child: const CircularProgressIndicator(),
          )
        : !remarkEditing
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
                            widget.buyer["remark"],
                          ),
                        ),
                        FlatButton(
                          child: const Text("Edit"),
                          onPressed: () {
                            setState(() {
                              remarkEditing = true;
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
                                initialValue: widget.buyer["remark"],
                                onChanged: (v) {
                                  remarkContent = v;
                                },
                                minLines: 9,
                                maxLines: 20,
                                decoration: const InputDecoration(
                                  labelText: "備註",
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  FlatButton(
                                    onPressed: () {
                                      setState(() {
                                        remarkEditing = false;
                                      });
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  FlatButton(
                                    onPressed: () =>
                                        updatingBuyerRemark(context),
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
