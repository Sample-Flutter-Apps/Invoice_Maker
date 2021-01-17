import 'package:flutter/material.dart';
import 'package:invoice_maker_2/providers/invoices.dart';
import 'package:invoice_maker_2/screens/new_invoice_screen.dart';
import 'package:invoice_maker_2/widgets/Invoice_List_Item.dart';
import 'package:invoice_maker_2/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

class InvoiceListScreen extends StatelessWidget {
  static const routeName = '/invoices';
  Future<void> _onPullRefresh(BuildContext context) async {
    await Provider.of<Invoices>(context, listen: false).fetchInvoices();
  }

  @override
  Widget build(BuildContext context) {
    //final invoices = Provider.of<Invoices>(context).invoices;
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoices'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewInvoiceScreen()),
              );
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _onPullRefresh(context),
        builder: (ctx, snapshotData) => snapshotData.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<Invoices>(
                builder: (ctx, invoiceData, child) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: invoiceData.invoices.length,
                    itemBuilder: (ctx, idx) => Column(
                      children: [
                        InvoiceListItem(
                          invoiceId: invoiceData.invoices[idx].invoiceId,
                          ownerId: invoiceData.invoices[idx].ownerId,
                          clientId: invoiceData.invoices[idx].clientId,
                          invoiceDate:
                              invoiceData.invoices[idx].createdDateTime,
                          totalAmount: invoiceData.invoices[idx].totalAmount,
                          ownerSignature:
                              invoiceData.invoices[idx].ownerSignature,
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
