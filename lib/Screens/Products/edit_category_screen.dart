// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Screens/Products/Model/category_model.dart';
import 'package:mobile_pos/constant.dart';

import 'Repo/category_repo.dart';

class EditCategory extends StatefulWidget {
  const EditCategory({Key? key, required this.categoryModel}) : super(key: key);

  final CategoryModel categoryModel;

  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<EditCategory> {
  bool showProgress = false;
  late String categoryName;
  bool sizeCheckbox = false;
  bool colorCheckbox = false;
  bool weightCheckbox = false;
  bool capacityCheckbox = false;
  bool typeCheckbox = false;
  TextEditingController categoryNameController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categoryNameController.text = widget.categoryModel.categoryName ?? '';
    sizeCheckbox = widget.categoryModel.variationSize ?? false;
    colorCheckbox = widget.categoryModel.variationColor ?? false;
    weightCheckbox = widget.categoryModel.variationWeight ?? false;
    capacityCheckbox = widget.categoryModel.variationSize ?? false;
    typeCheckbox = widget.categoryModel.variationType ?? false;
  }

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
            'Add Category',
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
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter category name',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Category name',
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Select variations : '),
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text(
                          "Size",
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
                        title: const Text(
                          "Color",
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
                        title: const Text(
                          "Weight",
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
                        title: const Text(
                          "Capacity",
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
                  title: const Text(
                    "Type",
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
                  buttontext: 'Save',
                  buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
                  onPressed: () async {
                    setState(() {
                      showProgress = true;
                    });
                    final categoryRepo = CategoryRepo();
                    await categoryRepo.editCategory(
                      id: widget.categoryModel.id ?? 0,
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
