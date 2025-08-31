import 'package:flutter/material.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

class GridItems {
  final String title, icon, route;

  GridItems({required this.title, required this.icon, required this.route});
}

List<GridItems> getFreeIcons({required BuildContext context}) {
  List<GridItems> freeIcons = [
    GridItems(title: lang.S.of(context).sale, icon: 'assets/sales.svg', route: 'Sales'),
    GridItems(title: lang.S.of(context).parties, icon: 'assets/parties.svg', route: 'Parties'),
    GridItems(title: lang.S.of(context).purchase, icon: 'assets/purchase.svg', route: 'Purchase'),
    GridItems(title: lang.S.of(context).product, icon: 'assets/products.svg', route: 'Products'),
    GridItems(title: lang.S.of(context).dueList, icon: 'assets/duelist.svg', route: 'Due List'),
    GridItems(title: lang.S.of(context).stockList, icon: 'assets/stock.svg', route: 'Stock'),
    GridItems(title: lang.S.of(context).reports, icon: 'assets/reports.svg', route: 'Reports'),
    GridItems(
      title: lang.S.of(context).saleList,
      icon: 'assets/salelist.svg',
      route: 'Sales List',
    ),
    GridItems(
      title: lang.S.of(context).purchaseList,
      icon: 'assets/purchaseLisst.svg',
      route: 'Purchase List',
    ),
    GridItems(
      title: lang.S.of(context).lossOrProfit,
      icon: 'assets/lossprofit.svg',
      route: 'Loss/Profit',
    ),
    GridItems(
      title: lang.S.of(context).expense,
      icon: 'assets/expense.svg',
      route: 'Expense',
    ),
    // Новые функции для бесплатного плана
    GridItems(
      title: 'Analytics',
      icon: 'assets/dashboard.svg',
      route: 'Analytics',
    ),
    GridItems(
      title: 'Notifications',
      icon: 'assets/notifications.svg',
      route: 'Notifications',
    ),
    GridItems(
      title: 'Settings',
      icon: 'assets/setting.svg',
      route: 'Settings',
    ),
  ];
  return freeIcons;
}

List<GridItems> freeIcons = [];

List<GridItems> businessIcons = [
  GridItems(
    title: 'Warehouse',
    icon: 'images/warehouse.png',
    route: 'Warehouse',
  ),
  GridItems(
    title: 'SalesReturn',
    icon: 'images/salesreturn.png',
    route: 'SalesReturn',
  ),
  GridItems(
    title: 'SalesList',
    icon: 'images/salelist.png',
    route: 'SalesList',
  ),
  GridItems(
    title: 'Quotation',
    icon: 'images/quotation.png',
    route: 'Quotation',
  ),
  GridItems(
    title: 'OnlineStore',
    icon: 'images/onlinestore.png',
    route: 'OnlineStore',
  ),
  GridItems(
    title: 'Supplier',
    icon: 'images/supplier.png',
    route: 'Supplier',
  ),
  GridItems(
    title: 'Invoice',
    icon: 'images/invoice.png',
    route: 'Invoice',
  ),
  GridItems(
    title: 'Stock',
    icon: 'images/stock.png',
    route: 'Stock',
  ),
  GridItems(
    title: 'Ledger',
    icon: 'images/ledger.png',
    route: 'Ledger',
  ),
  GridItems(
    title: 'Dashboard',
    icon: 'images/dashboard.png',
    route: 'Dashboard',
  ),
  GridItems(
    title: 'Bank',
    icon: 'images/bank.png',
    route: 'Bank',
  ),
  GridItems(
    title: 'Barcode',
    icon: 'images/barcodescan.png',
    route: 'Barcode',
  ),
  // Новые функции для бизнес-плана
  GridItems(
    title: 'Employee Management',
    icon: 'assets/userRole.svg',
    route: 'Employee Management',
  ),
  GridItems(
    title: 'Advanced Analytics',
    icon: 'assets/dashboard.svg',
    route: 'Advanced Analytics',
  ),
  GridItems(
    title: 'API Integration',
    icon: 'assets/api.svg',
    route: 'API Integration',
  ),
  GridItems(
    title: 'Backup & Sync',
    icon: 'assets/backup.svg',
    route: 'Backup & Sync',
  ),
];

List<GridItems> enterpriseIcons = [
  GridItems(
    title: 'Branch',
    icon: 'images/branch.png',
    route: 'Branch',
  ),
  GridItems(
    title: 'Damage',
    icon: 'images/damage.png',
    route: 'Damage',
  ),
  GridItems(
    title: 'Adjustment',
    icon: 'images/adjustment.png',
    route: 'Adjustment',
  ),
  GridItems(
    title: 'Transaction',
    icon: 'images/transaction.png',
    route: 'Transaction',
  ),
  GridItems(
    title: 'Gift',
    icon: 'images/gift.png',
    route: 'Gift',
  ),
  GridItems(
    title: 'Loss&Profit',
    icon: 'images/lossProfit.png',
    route: 'Loss&Profit',
  ),
  // Новые функции для enterprise-плана
  GridItems(
    title: 'Multi-Branch Management',
    icon: 'assets/branch.svg',
    route: 'Multi-Branch Management',
  ),
  GridItems(
    title: 'Advanced Security',
    icon: 'assets/security.svg',
    route: 'Advanced Security',
  ),
  GridItems(
    title: 'Custom Integrations',
    icon: 'assets/integration.svg',
    route: 'Custom Integrations',
  ),
  GridItems(
    title: 'White Label Solution',
    icon: 'assets/whitelabel.svg',
    route: 'White Label Solution',
  ),
  GridItems(
    title: 'Priority Support',
    icon: 'assets/support.svg',
    route: 'Priority Support',
  ),
  GridItems(
    title: 'Advanced Reporting',
    icon: 'assets/reports.svg',
    route: 'Advanced Reporting',
  ),
];
