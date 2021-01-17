import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:invoice_maker_2/providers/auth.dart';
import 'package:invoice_maker_2/providers/invoices.dart';
import 'package:invoice_maker_2/screens/home_screen.dart';
import 'package:invoice_maker_2/screens/invoice_list_screen.dart';
import 'package:invoice_maker_2/screens/auth_screen.dart';
import 'package:invoice_maker_2/screens/new_invoice_screen.dart';
import 'package:invoice_maker_2/screens/splash_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Invoices(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Invoice Manager',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: auth.isAuth
              ? HomeScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctxt, authSnapShot) =>
                      authSnapShot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            HomeScreen.routeName: (ctx) => HomeScreen(),
            InvoiceListScreen.routeName: (ctx) => InvoiceListScreen(),
            NewInvoiceScreen.routeName: (ctx) => NewInvoiceScreen(),
          },
        ),
      ),
    );
  }
}
