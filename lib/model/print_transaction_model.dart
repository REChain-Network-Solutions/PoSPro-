
import 'package:mobile_pos/model/sale_transaction_model.dart';

import '../Screens/Due Calculation/Model/due_collection_model.dart';
import '../Screens/Purchase/Model/purchase_transaction_model.dart';
import 'business_info_model.dart';

class PrintTransactionModel {
  PrintTransactionModel({required this.transitionModel, required this.personalInformationModel});

  BusinessInformation personalInformationModel;
  SalesTransaction? transitionModel;
}

class PrintPurchaseTransactionModel {
  PrintPurchaseTransactionModel({required this.purchaseTransitionModel, required this.personalInformationModel});

  BusinessInformation personalInformationModel;
  PurchaseTransaction? purchaseTransitionModel;
}

class PrintDueTransactionModel {
  PrintDueTransactionModel({required this.dueTransactionModel, required this.personalInformationModel});

  DueCollection? dueTransactionModel;
  BusinessInformation personalInformationModel;
}
