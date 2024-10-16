import '../../../model/sale_transaction_model.dart';
import '../../Customers/Model/parties_model.dart';

class DueCollection {
  DueCollection({
    this.id,
    this.businessId,
    this.partyId,
    this.userId,
    this.saleId,
    this.purchaseId,
    this.totalDue,
    this.dueAmountAfterPay,
    this.payDueAmount,
    this.paymentType,
    this.paymentDate,
    this.invoiceNumber,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.party,
  });

  DueCollection.fromJson(dynamic json) {
    id = json['id'];
    businessId = json['business_id'];
    partyId = json['party_id'];
    userId = json['user_id'];
    saleId = json['sale_id'];
    purchaseId = json['purchase_id'];
    totalDue = json['totalDue'];
    dueAmountAfterPay = json['dueAmountAfterPay'];
    payDueAmount = json['payDueAmount'];
    paymentType = json['paymentType'];
    paymentDate = json['paymentDate'];
    invoiceNumber = json['invoiceNumber'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    party = json['party'] != null ? Party.fromJson(json['party']) : null;
  }
  num? id;
  num? businessId;
  num? partyId;
  num? userId;
  num? saleId;
  num? purchaseId;
  num? totalDue;
  num? dueAmountAfterPay;
  num? payDueAmount;
  String? paymentType;
  String? invoiceNumber;
  String? paymentDate;
  String? createdAt;
  String? updatedAt;
  User? user;
  Party? party;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['business_id'] = businessId;
    map['party_id'] = partyId;
    map['user_id'] = userId;
    map['sale_id'] = saleId;
    map['purchase_id'] = purchaseId;
    map['totalDue'] = totalDue;
    map['dueAmountAfterPay'] = dueAmountAfterPay;
    map['payDueAmount'] = payDueAmount;
    map['paymentType'] = paymentType;
    map['paymentDate'] = paymentDate;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (user != null) {
      map['user'] = user?.toJson();
    }
    if (party != null) {
      map['party'] = party?.toJson();
    }
    return map;
  }
}

