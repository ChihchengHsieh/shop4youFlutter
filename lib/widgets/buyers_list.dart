import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop4you/providers/members.dart';
import 'package:shop4you/widgets/buyer_item.dart';

class BuyersList extends StatelessWidget {
  final String searchingStr;

   Widget whenNotInit(BuildContext ctx) {
    print("When not init Called");
    Provider.of<Members>(ctx).fetchAndSetMembers();
    return Center(
      child: const CircularProgressIndicator(),
    );
  }

  BuyersList(this.searchingStr);

  @override
  Widget build(BuildContext context) {
    return Consumer<Members>(
      child: const Center(
        child: const CircularProgressIndicator(),
      ),
      builder: (context, members, ch) {
        List<dynamic> showingBuyer = members.findMembersFromName(searchingStr);
        return Container(
          child: showingBuyer == null
              ? whenNotInit(context)
              : showingBuyer.length == 0
                  ? const Center(
                      child: Text("No Results..."),
                    )
                  : ListView.builder(
                      itemCount: showingBuyer.length,
                      itemBuilder: (ctx, i) => BuyerItem(showingBuyer[i]),
                    ),
        );
      },
    );
  }
}
