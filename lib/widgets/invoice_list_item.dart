import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:invoice_maker_2/model/list_item.dart';
import 'package:invoice_maker_2/providers/invoices.dart';
import 'package:invoice_maker_2/screens/invoice_edit_screen.dart';
import 'package:provider/provider.dart';

class InvoiceListItem extends StatelessWidget {
  final String invoiceId;
  final String ownerId;
  final String clientId;
  final double totalAmount;
  final DateTime invoiceDate;
  final ByteData ownerSignature;

  final List<ListItem> _dropdownItems = [
    ListItem("ID1", "Abc Ltd."),
    ListItem("ID2", "Xyz Ltd."),
    ListItem("ID3", "ZZZ Ltd."),
  ];

  InvoiceListItem(
      {this.invoiceId,
      this.ownerId,
      this.clientId,
      this.totalAmount,
      this.invoiceDate,
      this.ownerSignature});

  @override
  Widget build(BuildContext context) {
    //final scaffold = Scaffold.of(context);
    return ListTile(
      key: Key(invoiceId),
      leading: Text(invoiceId),
      title: Container(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Text(clientId),
              Text(DateFormat.yMMMd().format(invoiceDate)),
              Text('Rs.$totalAmount'),
            ],
          )),
      subtitle: Text(
          _dropdownItems.firstWhere((element) => element.id == clientId).name),
      trailing: Container(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditInvoiceScreen(
                      key: key,
                      invoiceId: invoiceId,
                      ownerId: ownerId,
                      clientId: clientId,
                      totalAmount: totalAmount,
                      invoiceDate: invoiceDate,
                      ownerSignature: ownerSignature,
                    ),
                  ),
                );
              },
              color: Theme.of(context).errorColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  await Provider.of<Invoices>(context, listen: false)
                      .deleteInvoice(invoiceId);
                } catch (error) {}
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
