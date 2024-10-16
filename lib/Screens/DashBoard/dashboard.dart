import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_pos/Screens/DashBoard/global_container.dart';
import 'package:mobile_pos/Screens/DashBoard/test_numeric.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/currency.dart';

import '../../Provider/profile_provider.dart';
import 'numeric_axis.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<String> timeList = [
    'Weekly',
    'Monthly',
    'Yearly',
  ];
  String selectedTimeList = 'Weekly';
  DropdownButton<String> getTime(WidgetRef ref) {
    List<DropdownMenuItem<String>> itemList = [];
    for (var des in timeList) {
      var item = DropdownMenuItem(
          value: des,
          child: Text(
            des,
            style: const TextStyle(color: kGreyTextColor, fontSize: 14, fontWeight: FontWeight.w500),
          ));
      itemList.add(item);
    }
    return DropdownButton(
        icon: const Icon(
          Icons.keyboard_arrow_down,
          color: kGreyTextColor,
          size: 18,
        ),
        value: selectedTimeList,
        items: itemList,
        onChanged: (value) {
          setState(() {
            selectedTimeList = value!;
            ref.refresh(dashboardInfoProvider(selectedTimeList.toLowerCase()));
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, ref, watch) {
      final dashboardInfo = ref.watch(dashboardInfoProvider(selectedTimeList.toLowerCase()));
      return dashboardInfo.when(data: (dashboard) {
        return Scaffold(
          backgroundColor: kBackgroundColor,
          appBar: AppBar(
            backgroundColor: kWhite,
            surfaceTintColor: kWhite,
            title:  Text(
              lang.S.of(context).dashboard,
                //'Dashboard'
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Container(
                    height: 32,
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    // width: 100,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: kBorderColorTextField)),
                    child: DropdownButtonHideUnderline(child: getTime(ref))),
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: kWhite),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lang.S.of(context).salesPurchaseOverview,
                         //'Sales & Purchase Overview',
                          style: gTextStyle.copyWith(fontWeight: FontWeight.bold, color: kTitleColor),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.circle,
                              color: Colors.green,
                              size: 18,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            RichText(
                                text:  TextSpan(text:
                                    lang.S.of(context).sales,
                                //'Sales',
                                    style: const TextStyle(color: kTitleColor), children: const [
                              // TextSpan(
                              //     text: '$currency 500',
                              //     style: gTextStyle.copyWith(fontWeight: FontWeight.bold,color: kTitleColor)
                              // ),
                            ])),
                            const SizedBox(
                              width: 20,
                            ),
                            const Icon(
                              Icons.circle,
                              color: kMainColor,
                              size: 18,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            RichText(
                                text:  TextSpan(text:
                                    lang.S.of(context).purchase,

                                //'Purchase',
                                    style: const TextStyle(color: kTitleColor), children: const [
                              // TextSpan(
                              //     text: '$currency 300',
                              //     style: gTextStyle.copyWith(fontWeight: FontWeight.bold,color: kTitleColor)
                              // ),
                            ])),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                            height: 250,
                            width: double.infinity,
                            child: DashboardChart(
                              model: dashboard,
                            )
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(child: GlobalContainer(
                          title:
                              lang.S.of(context).totalItems,
                          //'Total Items'
                           image: 'assets/totalItem.svg', subtitle: dashboard.data?.totalItems.toString() ?? '0')),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(child: GlobalContainer(
                          title:
                              lang.S.of(context).totalCategories,
                          //'Total Categories',
                          image: 'assets/purchaseLisst.svg', subtitle: dashboard.data?.totalCategories.toString() ?? '0'))
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    lang.S.of(context).quickOverview,
                    //'Quick Overview',
                    style: gTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: GlobalContainer(title:
                              lang.S.of(context).totalIncome,
                          //'Total Income',
                              image: 'assets/totalIncome.svg', subtitle: '$currency ${dashboard.data?.totalIncome.toString() ?? '0'}')),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(child: GlobalContainer(title:
                          lang.S.of(context).totalExpense,
                      //'Total Expense',
                          image: 'assets/expense.svg', subtitle: '$currency ${dashboard.data?.totalExpense.toString() ?? '0'}'))
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(child: GlobalContainer(title:
                          lang.S.of(context).customerDue,
                      //'Customer Due',
                          image: 'assets/duelist.svg', subtitle: '$currency ${dashboard.data?.totalDue.toString() ?? '0'}')),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(child: GlobalContainer(title:
                          lang.S.of(context).stockValue,
                      //'Stock Value',
                          image: 'assets/stock.svg', subtitle: dashboard.data?.stockValue.toString() ?? '0'))
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    lang.S.of(context).lossProfit,
                    //'Loss/Profit',
                    style: gTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: GlobalContainer(title:
                              lang.S.of(context).totalProfit,
                          //'Total Profit',
                              image: 'assets/lossprofit.svg', subtitle: '$currency ${dashboard.data?.totalProfit.toString() ?? '0'}')),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(child: GlobalContainer(title:
                          lang.S.of(context).totalLoss,
                      //'Toatal Loss',
                          image: 'assets/expense.svg', subtitle: '$currency ${dashboard.data?.totalLoss.toString() ?? '0'}'))
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }, error: (e, stack) {
        print(stack);
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No data found $e',
                  style: const TextStyle(color: kGreyTextColor, fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        );
      }, loading: () {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      });
    });
  }
}
