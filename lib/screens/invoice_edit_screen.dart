import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:invoice_maker_2/model/list_item.dart';
import 'package:invoice_maker_2/providers/invoice.dart';
import 'package:invoice_maker_2/providers/invoices.dart';
import 'package:invoice_maker_2/screens/invoice_list_screen.dart';
import 'package:invoice_maker_2/widgets/signature_pad.dart';
import 'package:provider/provider.dart';

class EditInvoiceScreen extends StatefulWidget {
  final String invoiceId;
  final String ownerId;
  final String clientId;
  final DateTime invoiceDate;
  final double totalAmount;
  final ByteData ownerSignature;

  const EditInvoiceScreen(
      {Key key,
      this.invoiceId,
      this.ownerId,
      this.clientId,
      this.invoiceDate,
      this.totalAmount,
      this.ownerSignature})
      : super(key: key);

  @override
  _EditInvoiceScreenState createState() => _EditInvoiceScreenState();
}

class _EditInvoiceScreenState extends State<EditInvoiceScreen> {
  String _invoiceId = '';
  ListItem _selectedOwnerItem;
  ListItem _selectedClientItem;
  double _totalAmount = 0.0;
  DateTime _invoiceDate;
  ByteData _ownerSignature = ByteData(0);

  List<ListItem> _dropdownItems = [
    ListItem("ID1", "Abc Ltd."),
    ListItem("ID2", "Xyz Ltd."),
    ListItem("ID3", "ZZZ Ltd."),
  ];

  List<DropdownMenuItem<ListItem>> _dropdownMenuItems;

  var _isLoading = false;

  final invoiceIdController = TextEditingController();
  final totalAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);

    _invoiceId = widget.invoiceId;
    invoiceIdController..text = widget.invoiceId;

    _totalAmount = widget.totalAmount;
    totalAmountController..text = widget.totalAmount.toString();

    _invoiceDate = widget.invoiceDate;
    _ownerSignature = widget.ownerSignature;

    for (var i = 0; i < _dropdownMenuItems.length; i++) {
      if (_dropdownMenuItems[i].value.id == widget.ownerId) {
        _selectedOwnerItem = _dropdownMenuItems[i].value;
      }
      if (_dropdownMenuItems[i].value.id == widget.clientId) {
        _selectedClientItem = _dropdownMenuItems[i].value;
      }
    }
  }

  @override
  void dispose() {
    invoiceIdController.dispose();
    totalAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Invoice'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              setState(() {
                _updateInvoice();
              });
            },
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    TextField(
                      enabled: false,
                      controller: invoiceIdController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Invoice Id',
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Owner'),
                        DropdownButton<ListItem>(
                            value: _selectedOwnerItem,
                            items: _dropdownMenuItems,
                            onChanged: (value) {
                              setState(() {
                                _selectedOwnerItem = value;
                              });
                            }),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Client'),
                        DropdownButton<ListItem>(
                            value: _selectedClientItem,
                            items: _dropdownMenuItems,
                            onChanged: (value) {
                              setState(() {
                                _selectedClientItem = value;
                              });
                            }),
                      ],
                    ),
                    TextField(
                      controller: totalAmountController,
                      decoration: InputDecoration(
                        labelText: 'Total Amount',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          this._totalAmount = double.parse(value);
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _invoiceDate == null
                              ? 'Please choose a date'
                              : DateFormat.yMMMd().format(_invoiceDate),
                          style: TextStyle(fontSize: 15),
                        ),
                        IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () async {
                            DateTime _pickedDateTime =
                                await _selectDate(context);
                            setState(() {
                              this._invoiceDate = _pickedDateTime;
                            });
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _ownerSignature.buffer.lengthInBytes == 0
                            ? Text('Add owner signature')
                            : LimitedBox(
                                maxHeight: 200.0,
                                child: Image.memory(
                                    _ownerSignature.buffer.asUint8List())),
                        IconButton(
                          icon: Icon(Icons.edit_attributes),
                          onPressed: () async {
                            final _signatureData = await Navigator.push(
                              context,
                              // Create the SignaturePad in the next step.
                              MaterialPageRoute(
                                  builder: (context) => SignaturePad()),
                            );
                            setState(() {
                              _ownerSignature = _signatureData;
                            });
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<DateTime> _selectDate(BuildContext context) async {
    final DateTime _pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    return _pickedDate;
  }

  List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<ListItem>> items = [];
    for (ListItem listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.name),
          value: listItem,
        ),
      );
    }
    return items;
  }

  Future<void> _updateInvoice() async {
    if (_invoiceId.isEmpty ||
        _totalAmount == 0.0 ||
        _invoiceDate == null ||
        _ownerSignature == null) {
      await _showMyDialog();
    } else {
      Invoice updatedInvoice = new Invoice(
        invoiceId: this._invoiceId,
        ownerId: this._selectedOwnerItem.id,
        clientId: this._selectedClientItem.id,
        totalAmount: this._totalAmount,
        createdDateTime: this._invoiceDate,
        ownerSignature: this._ownerSignature,
      );

      setState(() {
        _isLoading = true;
      });

      await Provider.of<Invoices>(context, listen: false)
          .updateInvoice(widget.invoiceId, updatedInvoice);

      setState(() {
        _isLoading = false;
      });

      Navigator.of(context).pushNamed(InvoiceListScreen.routeName);
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error Message'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please enter all the details'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
