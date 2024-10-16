import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Screens/Products/Model/category_model.dart';
import 'package:mobile_pos/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../GlobalComponents/button_global.dart';
import 'Providers/category,brans,units_provide.dart';
import 'Repo/category_repo.dart';
import 'Widgets/widgets.dart';
import 'add_category_screen.dart';
import 'edit_category_screen.dart';

// ignore: must_be_immutable
class CategoryList extends StatefulWidget {
  const CategoryList({Key? key, required this.isFromProductList}) : super(key: key);

  final bool isFromProductList;

  @override
  // ignore: library_private_types_in_public_api
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  String search = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        title: Text(
          'Categories',
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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Consumer(builder: (context, ref, __) {
          final categoryData = ref.watch(categoryProvider);
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
                        hintText: 'Search',
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
                  const SizedBox(width: 10.0),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        const AddCategory().launch(context);
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
                  // const SizedBox(width: 20.0),
                ],
              ),
              Expanded(
                child: categoryData.when(data: (data) {
                  return SingleChildScrollView(
                    child: data.isNotEmpty
                        ? ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: data.length,
                            itemBuilder: (context, i) {
                              final List<String> variations = [];
                              (data[i].variationSize ?? false) ? variations.add('Size') : null;
                              (data[i].variationColor ?? false) ? variations.add('Color') : null;
                              data[i].variationCapacity ?? false ? variations.add('Capacity') : null;
                              data[i].variationType ?? false ? variations.add('Type') : null;
                              data[i].variationWeight ?? false ? variations.add('Weight') : null;

                              GetCategoryAndVariationModel get = GetCategoryAndVariationModel(categoryName: data[i], variations: variations);
                              return (data[i].categoryName ?? '').toLowerCase().contains(search.toLowerCase())
                                  ? GestureDetector(
                                      onTap: widget.isFromProductList
                                          ? () {}
                                          : () {
                                              Navigator.pop(context, get);
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
                                                  data[i].categoryName.toString(),
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 18.0,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                const Spacer(),
                                                Row(
                                                  children: [
                                                    IconButton(
                                                        padding: EdgeInsets.zero,
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) => EditCategory(
                                                                  categoryModel: data[i],
                                                                ),
                                                              ));
                                                        },
                                                        icon: const Icon(Icons.edit)),
                                                    IconButton(
                                                      visualDensity: const VisualDensity(horizontal: -4),
                                                       padding: EdgeInsets.zero,
                                                        onPressed: () async {
                                                          bool confirmDelete = await showDeleteAlert(context: context, itemsName: 'category');
                                                          if (confirmDelete) {
                                                            EasyLoading.show();
                                                            if (await CategoryRepo().deleteCategory(context: context, categoryId: data[i].id ?? 0)) {
                                                              ref.refresh(categoryProvider);
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
                          ),
                  );
                }, error: (_, __) {
                  return Container();
                }, loading: () {
                  return const Center(child: SizedBox(height: 40, width: 40, child: CircularProgressIndicator()));
                }),
              ),
            ],
          );
        }),
      ),
    );
  }
}
