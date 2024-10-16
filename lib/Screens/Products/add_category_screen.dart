// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/constant.dart';

import 'Repo/category_repo.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

class AddCategory extends StatefulWidget {
  const AddCategory({Key? key}) : super(key: key);

  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  bool showProgress = false;
  late String categoryName;
  bool sizeCheckbox = false;
  bool colorCheckbox = false;
  bool weightCheckbox = false;
  bool capacityCheckbox = false;
  bool typeCheckbox = false;
  TextEditingController categoryNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      return Scaffold(
        backgroundColor: kWhite,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Image(
                image: AssetImage('images/x.png'),
              )),
          title: Text(
            lang.S.of(context).addCategory,
            //'Add Category',
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
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Visibility(
                  visible: showProgress,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      color: kMainColor,
                      strokeWidth: 5.0,
                    ),
                  ),
                ),
                TextFormField(
                  controller: categoryNameController,
                  decoration:  InputDecoration(
                    border: OutlineInputBorder(),
                    //hintText: 'Enter category name',
                    hintText: lang.S.of(context).enterCategoryName,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    //labelText: 'Category name',
                    labelText: lang.S.of(context).categoryName,
                  ),
                ),
                const SizedBox(height: 20),
                 Text(lang.S.of(context).selectVariations
                     //'Select variations : '
                 ),
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title:  Text(
                          lang.S.of(context).size,
                          //"Size",

                          overflow: TextOverflow.ellipsis,
                        ),
                        value: sizeCheckbox,
                        checkboxShape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                        onChanged: (newValue) {
                          setState(() {
                            sizeCheckbox = newValue!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        title:  Text(
                          lang.S.of(context).color,
                          //"Color",
                          overflow: TextOverflow.ellipsis,
                        ),
                        value: colorCheckbox,
                        checkboxShape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                        onChanged: (newValue) {
                          setState(() {
                            colorCheckbox = newValue!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title:  Text(
                          lang.S.of(context).weight,
                          //"Weight",
                          overflow: TextOverflow.ellipsis,
                        ),
                        checkboxShape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                        value: weightCheckbox,
                        onChanged: (newValue) {
                          setState(() {
                            weightCheckbox = newValue!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        title:  Text(
                          lang.S.of(context).capacity,
                          //"Capacity",
                          overflow: TextOverflow.ellipsis,
                        ),
                        checkboxShape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                        value: capacityCheckbox,
                        onChanged: (newValue) {
                          setState(() {
                            capacityCheckbox = newValue!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
                      ),
                    ),
                  ],
                ),
                CheckboxListTile(
                  title:  Text(
                    lang.S.of(context).type,
                    //"Type",
                    overflow: TextOverflow.ellipsis,
                  ),
                  checkboxShape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                  value: typeCheckbox,
                  onChanged: (newValue) {
                    setState(() {
                      typeCheckbox = newValue!;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
                ),
                ButtonGlobalWithoutIcon(
                  buttontext:lang.S.of(context).save,
                  //'Save',
                  buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
                  onPressed: () async {
                    setState(() {
                      showProgress = true;
                    });
                    final categoryRepo = CategoryRepo();
                    await categoryRepo.addCategory(
                      ref: ref,
                      context: context,
                      name: categoryNameController.text,
                      variationSize: sizeCheckbox,
                      variationColor: colorCheckbox,
                      variationCapacity: capacityCheckbox,
                      variationType: typeCheckbox,
                      variationWeight: weightCheckbox,
                    );
                    setState(() {
                      showProgress = false;
                    });
                  },
                  buttonTextColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
