import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_pos/Screens/Products/Model/product_model.dart';

final cartNotifierPurchase = ChangeNotifierProvider((ref) => CartNotifier());

class CartNotifier extends ChangeNotifier {
  List<ProductModel> cartItemPurchaseList = [];
  double discount = 0;
  String discountType = 'USD';
  List<TextEditingController> controllers = [];
  List<FocusNode> focus = [];

  final List<ProductModel> productList = [];

  void addProductsInSales(ProductModel products) {
    productList.add(products);
    notifyListeners();
  }

  double getTotalAmount() {
    double totalAmountOfCart = 0;
    for (var element in cartItemPurchaseList) {
      totalAmountOfCart = totalAmountOfCart + (double.parse(element.productPurchasePrice.toString()) * double.parse(element.productStock.toString()));
    }
    return totalAmountOfCart;
  }

  addToCartRiverPod(ProductModel cartItem) {
    bool isNotInList = true;
    for (var element in cartItemPurchaseList) {
      if (element.productCode == cartItem.productCode) {
        element.productStock = ((element.productStock ?? 0) + (cartItem.productStock ?? 0));
        element.productSalePrice = cartItem.productSalePrice;
        element.productPurchasePrice = cartItem.productPurchasePrice;
        element.productDealerPrice = cartItem.productDealerPrice;
        element.productWholeSalePrice = cartItem.productWholeSalePrice;

        isNotInList = false;
        return;
      } else {
        isNotInList = true;
      }
    }
    if (isNotInList) {
      cartItemPurchaseList.add(cartItem);
      controllers.add(TextEditingController());
      focus.add(FocusNode());
    }
    notifyListeners();
  }

  addToCartRiverPodForEdit(List<ProductModel> cartItem) {
    // cartItemPurchaseList.addAll(iterable)
    cartItemPurchaseList = cartItem;
    notifyListeners();
  }

  quantityDecrease(int index) {
    if ((cartItemPurchaseList[index].productStock ?? 0) > 1) {
      int quantity = (cartItemPurchaseList[index].productStock ?? 0).round();
      quantity--;
      cartItemPurchaseList[index].productStock = quantity;
    }
    notifyListeners();
  }

  quantityIncrease(int index) {
    int quantity = (cartItemPurchaseList[index].productStock ?? 0).round();
    quantity++;
    cartItemPurchaseList[index].productStock = quantity;
    notifyListeners();
  }

  clearCart() {
    cartItemPurchaseList.clear();
    clearDiscount();
    notifyListeners();
  }

  deleteToCart(int index) {
    cartItemPurchaseList.removeAt(index);
    notifyListeners();
  }

  addDiscount(String type, double dis) {
    discount = dis;
    discountType = type;
    notifyListeners();
  }

  clearDiscount() {
    discount = 0;
    discountType = 'USD';
    notifyListeners();
  }
}
