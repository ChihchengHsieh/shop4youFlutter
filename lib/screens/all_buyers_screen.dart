import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop4you/providers/members.dart';
import 'package:shop4you/widgets/app_drawer.dart';
import 'package:shop4you/widgets/buyers_list.dart';

class AllBuyersScreen extends StatefulWidget {
  @override
  _AllBuyersScreenState createState() => _AllBuyersScreenState();
}

enum PopUpMenuOption { RefetchingMembers }

class _AllBuyersScreenState extends State<AllBuyersScreen> {
  Widget whenNotInit(BuildContext ctx) {
    Provider.of<Members>(ctx).fetchAndSetMembers();

    return Container(
      height: MediaQuery.of(ctx).size.height * 0.5,
      child: const Center(
        child: const CircularProgressIndicator(),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchingAllMembers() async {
    await Provider.of<Members>(context).fetchAndSetMembers();
  }

  String _buyerNameStr;

  @override
  Widget build(BuildContext context) {
    print("all buyer screen is called");

    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: TextField(
                onChanged: (val) {
                  setState(() {
                    _buyerNameStr = val;
                  });
                },
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors.white,
                          width: 0.0,
                          style: BorderStyle.solid),
                    ),
                    focusColor: Colors.white,
                    labelStyle: const TextStyle(color: Colors.white),
                    labelText: "搜尋...",
                    focusedBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.white,
                        width: 0.0,
                        style: BorderStyle.solid,
                      ),
                    )),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.15,
              padding: const EdgeInsets.only(
                top: 5,
                bottom: 5,
                right: 10,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () async {
                  await Provider.of<Members>(context, listen: false)
                      .addNewMember(_buyerNameStr);
                  // setState(() {
                  //   _updateShowingBuyers(_searchingStringController.text);
                  // });
                },
              ),
            )
          ],
        ),
        drawer: AppDrawer(),
        body: RefreshIndicator(
          onRefresh: () => _fetchingAllMembers(),
          child: BuyersList(_buyerNameStr),
        ));
  }
}

// B);
