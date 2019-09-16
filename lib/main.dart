import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop4you/providers/auth.dart';
import 'package:shop4you/providers/members.dart';
import 'package:shop4you/screens/all_buyers_screen.dart';
import 'package:shop4you/screens/all_products_screen.dart';
import 'package:shop4you/screens/auth_screen.dart';
import 'package:shop4you/screens/buyer_detail_screen.dart';
import 'package:shop4you/screens/delivery_screen.dart';
import 'package:shop4you/screens/shopping_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Members>(
          initialBuilder: (_) => Members(),
          builder: (ctx, auth, prevMembers) => prevMembers..token = auth.token,
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          onGenerateRoute: (settings) {
            if (settings.name == BuyerDetailScreen.routeName) {
              return MaterialPageRoute(builder: (context) {
                final args = settings.arguments as Map<String,
                    dynamic>; // get buyers and sorted product here
                var buyer;
                if (args["buyer"] != null) {
                  buyer = args["buyer"];
                } else {
                  buyer = Provider.of<Members>(context, listen: false)
                      .findBuyerById(args["buyerId"]);
                }

              
                return BuyerDetailScreen(
                  buyer: buyer,
                );
              });
            }
          },
          debugShowCheckedModeBanner: false,
          debugShowMaterialGrid: false,
          title: 'Shop4you',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.amber,
          ),
          home: auth.isLogin
              ? AllBuyersScreen() // Main Screen
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? Container() // SplashScreen
                          : AuthScreen(), //AuthScreen
                ),
          routes: {
            AllProductsScreen.routeName: (ctx) => AllProductsScreen(),
            // BuyerDetailScreen.routeName: (ctx) => BuyerDetailScreen(),
            ShoppingScreen.routeName: (ctx) => ShoppingScreen(),
            DeliveryScreen.routeName: (ctx) => DeliveryScreen(),
          },
        ),
      ),
    );
  }
}
