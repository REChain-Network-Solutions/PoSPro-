class DueCollectionInvoice {
  DueCollectionInvoice({
    this.id,
    this.due,
    this.name,
    this.type,
    this.salesDues,
  });

  DueCollectionInvoice.fromJson(dynamic json) {
    id = json['id'];
    due = json['due'];
    name = json['name'];
    type = json['type'];
    if (json[json['type'] == 'Supplier'?'purchases_dues':'sales_dues'] != null) {
      salesDues = [];
      json[json['type'] == 'Supplier'?'purchases_dues':'sales_dues'].forEach((v) {
        salesDues?.add(SalesDuesInvoice.fromJson(v));
      });
    }
  }
  num? id;
  num? due;
  String? name;
  String? type;
  List<SalesDuesInvoice>? salesDues;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['due'] = due;
    map['name'] = name;
    map['type'] = type;
    if (salesDues != null) {
      map['sales_dues'] = salesDues?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class SalesDuesInvoice {
  SalesDuesInvoice({
    this.id,
    this.partyId,
    this.dueAmount,
    this.paidAmount,
    this.totalAmount,
    this.invoiceNumber,
  });

  SalesDuesInvoice.fromJson(dynamic json) {
    id = json['id'];
    partyId = json['party_id'];
    dueAmount = json['dueAmount'];
    paidAmount = json['paidAmount'];
    totalAmount = json['totalAmount'];
    invoiceNumber = json['invoiceNumber'];
  }
  num? id;
  num? partyId;
  num? dueAmount;
  num? paidAmount;
  num? totalAmount;
  String? invoiceNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['party_id'] = partyId;
    map['dueAmount'] = dueAmount;
    map['paidAmount'] = paidAmount;
    map['totalAmount'] = totalAmount;
    map['invoiceNumber'] = invoiceNumber;
    return map;
  }
}
