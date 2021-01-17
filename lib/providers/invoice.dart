import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class Invoice with ChangeNotifier {
  final String invoiceId;
  final String ownerId;
  final String clientId;
  final double totalAmount;
  final DateTime createdDateTime;
  final ByteData ownerSignature;

  Invoice(
      {this.invoiceId,
      this.ownerId,
      this.clientId,
      this.totalAmount,
      this.createdDateTime,
      this.ownerSignature});
}
