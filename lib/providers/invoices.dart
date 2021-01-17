import 'package:flutter/material.dart';
import 'package:invoice_maker_2/providers/invoice.dart';

class Invoices with ChangeNotifier {
  List<Invoice> _invoices = [
    // Invoice(
    //     invoiceId: "I1",
    //     ownerId: "O1",
    //     clientId: "C1",
    //     totalAmount: 100,
    //     createdDateTime: DateTime.parse("2020-10-07T12:22")),
    // Invoice(
    //     invoiceId: "I2",
    //     ownerId: "O1",
    //     clientId: "C2",
    //     totalAmount: 200,
    //     createdDateTime: DateTime.parse("2020-10-07T12:22")),
    // Invoice(
    //     invoiceId: "I3",
    //     ownerId: "O1",
    //     clientId: "C3",
    //     totalAmount: 300,
    //     createdDateTime: DateTime.parse("2020-10-07T12:22")),
  ];

  Future<void> fetchInvoices() async {
    // final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    // final url = 'https://glossy-calculus-279617.firebaseio.com/products.json?auth=$authToken&$filterString';
    // try {
    //   final response = await http.get(url);
    //   final extractedData = json.decode(response.body) as Map<String, dynamic>;
    //   if(extractedData == null){
    //     return;
    //   }

    //   final url2 =
    //     'https://glossy-calculus-279617.firebaseio.com/userFavourites/$userId.json?auth=$authToken';
    //   final response2 = await http.get(url2);
    //   final favouriteData = json.decode(response2.body);

    //   //print(extractedData);
    //   final List<Product> loadedProducts = [];
    //   extractedData.forEach((prodId, prodData) {
    //     loadedProducts.add(Product(
    //       id: prodId,
    //       title: prodData['title'],
    //       description: prodData['description'],
    //       price: prodData['price'],
    //       isFavourite: favouriteData == null ? false : favouriteData[prodId] ?? false,
    //       imageUrl: prodData['imageUrl'],
    //     ));
    //   });
    //   _items = loadedProducts;
    //   notifyListeners();
    // } catch (error) {
    //   throw error;
    // }
    //notifyListeners();
  }

  Future<void> addInvoice(Invoice invoice) async {
    // final url =
    //     'https://glossy-calculus-279617.firebaseio.com/products.json?auth=$authToken';
    // try {
    //   final response = await http.post(
    //     url,
    //     body: json.encode({
    //       'title': product.title,
    //       'description': product.description,
    //       'imageUrl': product.imageUrl,
    //       'price': product.price,
    //       'creatorId': userId,
    //     }),
    //   );
    Invoice newInvoice = new Invoice(
      invoiceId: invoice.invoiceId,
      ownerId: invoice.ownerId,
      clientId: invoice.clientId,
      totalAmount: invoice.totalAmount,
      createdDateTime: invoice.createdDateTime,
      ownerSignature: invoice.ownerSignature,
    );
    //print(newInvoice.toString());
    _invoices.add(newInvoice);
    notifyListeners();
    // } catch (error) {
    //   throw error;
    // }
  }

  Future<void> updateInvoice(String invoiceId, Invoice invoice) async {
    int _invIndex = _invoices.indexWhere((inv) => inv.invoiceId == invoiceId);
    if (_invIndex >= 0) {
      // final url =
      //     'https://glossy-calculus-279617.firebaseio.com/products/$productId.json?auth=$authToken';
      // await http.patch(url,
      //     body: json.encode({
      //       'title': product.title,
      //       'description': product.description,
      //       'imageUrl': product.imageUrl,
      //       'price': product.price,
      //     }));

      _invoices[_invIndex] = invoice;
      notifyListeners();
    }
  }

  Future<void> deleteInvoice(String invoiceId) async {
    int _invIndex = _invoices.indexWhere((inv) => inv.invoiceId == invoiceId);
    _invoices.removeAt(_invIndex);
    //debugPrint(_invoices.length.toString());
    notifyListeners();
  }

  List<Invoice> get invoices {
    return [..._invoices];
  }

  Invoice findById(String invoiceId) {
    return _invoices.firstWhere((invoice) => invoice.invoiceId == invoiceId);
  }
}
