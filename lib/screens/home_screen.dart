import 'package:flutter/material.dart';
import 'package:invoice_maker_2/screens/new_invoice_screen.dart';
import 'package:invoice_maker_2/screens/pdf_generate_screen.dart';
import 'package:invoice_maker_2/widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice Manager'),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PdfGenerateScreen(),
                ),
              );
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Container(
          margin: EdgeInsets.only(bottom: 20.0),
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.deepOrange.shade900,
            boxShadow: [
              BoxShadow(
                blurRadius: 8,
                color: Colors.black26,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            'Welcome to Invoice Manager',
            style: TextStyle(
              // ignore: deprecated_member_use
              color: Theme.of(context).accentTextTheme.title.color,
              fontSize: 17,
              fontFamily: 'Anton',
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewInvoiceScreen()),
          );
        },
        //backgroundColor: Theme.of(context).appBarTheme.color,
        icon: Icon(Icons.add),
        label: Text("Invoice"),
      ),
    );
  }
}
