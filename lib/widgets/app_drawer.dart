import 'package:flutter/material.dart';
import 'package:invoice_maker_2/providers/auth.dart';
import 'package:invoice_maker_2/screens/home_screen.dart';
import 'package:invoice_maker_2/screens/invoice_list_screen.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Hello!'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            title: Text('Home'),
            leading: Icon(Icons.home),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            title: Text('Invoices'),
            leading: Icon(Icons.payment),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(InvoiceListScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            title: Text('Estimates'),
            leading: Icon(Icons.money),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(InvoiceListScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            title: Text('Logout'),
            leading: Icon(Icons.exit_to_app),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed(
                  '/'); //Do this to always go to Home Screen so that your Auth logic in main dart
              //just to avoid unexpected behaviour
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
