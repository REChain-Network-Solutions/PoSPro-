import 'dart:convert';

class AddToCartModel {
  AddToCartModel({
    required this.uuid,
    this.productId,
    this.productName,
    this.unitPrice,
    this.subTotal,
    this.quantity = 1,
    this.productDetails,
    this.itemCartIndex = -1,
    this.uniqueCheck,
    this.productBrandName,
    this.stock,
    this.productPurchasePrice,
  });

  num uuid;
  dynamic productId;
  String? productName;
  dynamic unitPrice;
  dynamic subTotal;
  dynamic productPurchasePrice;
  dynamic uniqueCheck;
  int quantity = 1;
  dynamic productDetails;
  dynamic productBrandName;
  // Item store on which index of cart so we can update or delete cart easily, initially it is -1
  int itemCartIndex;
  int? stock;

  factory AddToCartModel.fromJson(String str) => AddToCartModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AddToCartModel.fromMap(Map<String, dynamic> json) => AddToCartModel(
        uuid: json["uuid"],
        productId: json["product_id"],
        productName: json["product_name"],
        productBrandName: json["product_brand_name"],
        unitPrice: json["unit_price"],
        subTotal: json["sub_total"],
        uniqueCheck: json["unique_check"],
        quantity: json["quantity"],
        productDetails: json["product_details"],
        itemCartIndex: json["item_cart_index"],
        stock: json["stock"],
        productPurchasePrice: json["productPurchasePrice"],
      );

  Map<String, dynamic> toMap() => {
        "uuid": uuid,
        "product_id": productId,
        "product_name": productName,
        "product_brand_name": productBrandName,
        "unit_price": unitPrice,
        "sub_total": subTotal,
        "unique_check": uniqueCheck,
        "quantity": quantity == 0 ? null : quantity,
        "item_cart_index": itemCartIndex,
        "stock": stock,
        "productPurchasePrice": productPurchasePrice,
        // ignore: prefer_null_aware_operators
        "product_details": productDetails == null ? null : productDetails.toJson(),
      };
}
