import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Screens/Customers/Model/parties_model.dart';
import 'package:mobile_pos/Screens/Due%20Calculation/due_collection_screen.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

import '../../Const/api_config.dart';
import '../../constant.dart';
import '../../currency.dart';
import '../Customers/Provider/customer_provider.dart';

class DueCalculationContactScreen extends StatefulWidget {
  const DueCalculationContactScreen({Key? key}) : super(key: key);

  @override
  State<DueCalculationContactScreen> createState() => _DueCalculationContactScreenState();
}

class _DueCalculationContactScreenState extends State<DueCalculationContactScreen> {
  late Color color;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          lang.S.of(context).dueList,
          style: GoogleFonts.poppins(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Consumer(builder: (context, ref, __) {
            final providerData = ref.watch(partiesProvider);

            return providerData.when(data: (parties) {
              List<Party> dueCustomerList =[];

              for (var party in parties) {
                if((party.due ?? 0) > 0){
                  dueCustomerList.add(party);
                }
              }
              return dueCustomerList.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: dueCustomerList.length,
                      itemBuilder: (_, index) {
                        dueCustomerList[index].type == 'Retailer' ? color = const Color(0xFF56da87) : Colors.white;
                        dueCustomerList[index].type == 'Wholesaler' ? color = const Color(0xFF25a9e0) : Colors.white;
                        dueCustomerList[index].type == 'Dealer' ? color = const Color(0xFFff5f00) : Colors.white;
                        dueCustomerList[index].type == 'Supplier' ? color = const Color(0xFFA569BD) : Colors.white;

                        return GestureDetector(
                          onTap: () {
                            DueCollectionScreen(customerModel: dueCustomerList[index]).launch(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 50.0,
                                  width: 50.0,
                                  child: CircleAvatar(
                                    foregroundColor: Colors.blue,
                                    backgroundColor: Colors.white,
                                    radius: 70.0,
                                    child: ClipOval(
                                      child: dueCustomerList[index].image != null
                                          ? Image.network(
                                              '${APIConfig.domain}${dueCustomerList[index].image ?? ''}',
                                              fit: BoxFit.cover,
                                              width: 120.0,
                                              height: 120.0,
                                            )
                                          : Image.asset(
                                              'images/no_shop_image.png',
                                              fit: BoxFit.cover,
                                              width: 120.0,
                                              height: 120.0,
                                            ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      dueCustomerList[index].name ?? '',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    Text(
                                      dueCustomerList[index].type ?? '',
                                      style: GoogleFonts.poppins(
                                        color: color,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '$currency ${dueCustomerList[index].due}',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    Text(
                                      lang.S.of(context).due,
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFFff5f00),
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ],
                                ).visible(dueCustomerList[index].due != 0),
                                const SizedBox(width: 20),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  color: kGreyTextColor,
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                  : Center(
                      child: Text(
                        lang.S.of(context).noDataAvailabe,
                        maxLines: 2,
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                    );
            }, error: (e, stack) {
              return Text(e.toString());
            }, loading: () {
              return const Center(child: CircularProgressIndicator());
            });
          }),
        ),
      ),
    );
  }
}
