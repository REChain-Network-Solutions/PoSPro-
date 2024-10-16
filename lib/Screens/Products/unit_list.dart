import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Screens/Products/Providers/category,brans,units_provide.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

import '../../GlobalComponents/button_global.dart';
import 'Repo/unit_repo.dart';
import 'Widgets/widgets.dart';
import 'add_units.dart';

// ignore: must_be_immutable
class UnitList extends StatefulWidget {
  const UnitList({Key? key, required this.isFromProductList}) : super(key: key);

  final bool isFromProductList;

  @override
  // ignore: library_private_types_in_public_api
  _UnitListState createState() => _UnitListState();
}

class _UnitListState extends State<UnitList> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        title: Text(
          lang.S.of(context).units,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 20.0,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Consumer(builder: (context, ref, __) {
            final unitData = ref.watch(unitsProvider);
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: AppTextField(
                        textFieldType: TextFieldType.NAME,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: lang.S.of(context).search,
                          prefixIcon: Icon(
                            Icons.search,
                            color: kGreyTextColor.withOpacity(0.5),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            search = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          const AddUnits().launch(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                          height: 57.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(color: kGreyTextColor),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: kGreyTextColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                unitData.when(data: (data) {
                  return data.isNotEmpty
                      ? ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (context, i) {
                            return (data[i].unitName ?? '').toLowerCase().contains(search.toLowerCase())
                                ? GestureDetector(
                                    onTap: widget.isFromProductList
                                        ? () {}
                                        : () {
                                            Navigator.pop(context, data[i]);
                                          },
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Container(
                                        height: 65,
                                        decoration: BoxDecoration(border: Border.all(color: kBorderColor), borderRadius: const BorderRadius.all(Radius.circular(10))),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                data[i].unitName ?? '',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 18.0,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const Spacer(),
                                              Row(
                                                children: [
                                                  IconButton(
                                                     visualDensity:const VisualDensity(horizontal: -4),
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>  AddUnits(unit: data[i],),
                                                            ));
                                                      },
                                                      icon: const Icon(Icons.edit)),
                                                  IconButton(
                                                      onPressed: () async {
                                                        bool confirmDelete = await showDeleteAlert(context: context, itemsName: 'unit');
                                                        if (confirmDelete) {
                                                          EasyLoading.show();
                                                          if (await UnitsRepo().deleteUnit(context: context, unitId: data[i].id ?? 0)) {
                                                            ref.refresh(unitsProvider);
                                                          }
                                                          EasyLoading.dismiss();
                                                        }
                                                      },
                                                      icon: const Icon(
                                                        Icons.delete,
                                                        color: Colors.redAccent,
                                                      )),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container();
                          })
                      : const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text('No Data Found'),
                        );
                }, error: (_, __) {
                  return Container();
                }, loading: () {
                  return const CircularProgressIndicator();
                }),
              ],
            );
          }),
        ),
      ),
    );
  }
}
