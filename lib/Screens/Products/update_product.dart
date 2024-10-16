// ignore_for_file: unused_result
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_pos/Const/api_config.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Screens/Products/Model/brands_model.dart' as brand;
import 'package:mobile_pos/Screens/Products/Model/product_model.dart';
import 'package:mobile_pos/Screens/Products/Model/unit_model.dart' as unit;
import 'package:mobile_pos/Screens/Products/Repo/product_repo.dart';
import 'package:mobile_pos/Screens/Products/unit_list.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';
import '../../constant.dart';
import 'Model/category_model.dart';
import 'brands_list.dart';
import 'category_list_screen.dart';

// ignore: must_be_immutable
class UpdateProduct extends StatefulWidget {
  const UpdateProduct({Key? key,  this.productModel}) : super(key: key);

 final ProductModel ? productModel;

  @override
  // ignore: library_private_types_in_public_api
  _UpdateProductState createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  GetCategoryAndVariationModel data = GetCategoryAndVariationModel(variations: [], categoryName: CategoryModel());
  bool showProgress = false;
  final ImagePicker _picker = ImagePicker();
  XFile? pickedImage;
  GlobalKey<FormState> key = GlobalKey();

  TextEditingController nameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController productUnitController = TextEditingController();
  TextEditingController productStockController = TextEditingController();
  TextEditingController salePriceController = TextEditingController();
  TextEditingController discountPriceController = TextEditingController();
  TextEditingController purchasePriceController = TextEditingController();
  TextEditingController productCodeController = TextEditingController();
  TextEditingController wholeSalePriceController = TextEditingController();
  TextEditingController dealerPriceController = TextEditingController();
  TextEditingController manufacturerController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController capacityController = TextEditingController();
  CategoryModel? selectedCategory;
  brand.Brand? selectedBrand;
  unit.Unit? selectedUnit;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.productModel?.productName ?? '';
    categoryController.text = widget.productModel?.category?.categoryName ?? '';
    brandController.text = widget.productModel?.brand?.brandName ?? '';
    productUnitController.text = widget.productModel?.unit?.unitName ?? '';
    productStockController.text = widget.productModel?.productStock.toString() ?? '';
    salePriceController.text = widget.productModel?.productSalePrice.toString() ?? '';
    discountPriceController.text = widget.productModel?.productDiscount.toString() ?? '';
    purchasePriceController.text = widget.productModel?.productPurchasePrice.toString() ?? '';
    productCodeController.text = widget.productModel?.productCode ?? '';
    wholeSalePriceController.text = widget.productModel?.productWholeSalePrice.toString() ?? '';
    dealerPriceController.text = widget.productModel?.productDealerPrice.toString() ?? '';
    manufacturerController.text = widget.productModel?.productManufacturer ?? '';
    sizeController.text = widget.productModel?.size ?? '';
    colorController.text = widget.productModel?.color ?? '';
    weightController.text = widget.productModel?.weight ?? '';
    typeController.text = widget.productModel?.type ?? '';
    capacityController.text = widget.productModel?.capacity ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      return Scaffold(
        backgroundColor: kWhite,
        appBar: AppBar(
          surfaceTintColor: kWhite,
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          title: Text(
            lang.S.of(context).updateProduct,
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          // actions: [
          //   IconButton(
          //     onPressed: () {
          //       showDialog(
          //         barrierDismissible: false,
          //         context: context,
          //         builder: (BuildContext context1) {
          //           return Padding(
          //             padding: const EdgeInsets.all(30.0),
          //             child: Center(
          //               child: Container(
          //                 decoration: const BoxDecoration(
          //                   color: Colors.white,
          //                   borderRadius: BorderRadius.all(Radius.circular(30)),
          //                 ),
          //                 child: Padding(
          //                   padding: const EdgeInsets.all(10.0),
          //                   child: Column(
          //                     crossAxisAlignment: CrossAxisAlignment.center,
          //                     mainAxisSize: MainAxisSize.min,
          //                     children: [
          //                       const SizedBox(height: 20),
          //                       Text(
          //                         lang.S.of(context).youWantTodeletetheProduct,
          //                         textAlign: TextAlign.center,
          //                         style: const TextStyle(
          //                           fontSize: 22,
          //                         ),
          //                       ),
          //                       const SizedBox(height: 20),
          //                       Row(
          //                         mainAxisSize: MainAxisSize.min,
          //                         children: [
          //                           Expanded(
          //                             child: ButtonGlobalWithoutIcon(
          //                               buttontext: lang.S.of(context).cancel,
          //                               buttonDecoration: kButtonDecoration.copyWith(color: Colors.green),
          //                               onPressed: (() {
          //                                 Navigator.pop(context1);
          //                               }),
          //                               buttonTextColor: Colors.white,
          //                             ),
          //                           ),
          //                           Expanded(
          //                             child: ButtonGlobalWithoutIcon(
          //                               buttontext: lang.S.of(context).delete,
          //                               buttonDecoration: kButtonDecoration.copyWith(color: Colors.red),
          //                               onPressed: (() async {
          //                                 EasyLoading.show(status: 'Deleting....');
          //                                 ProductRepo productRepo = ProductRepo();
          //                                 await productRepo.deleteProduct(id: widget.productModel!.id.toString(), context: context, ref: ref);
          //                               }),
          //                               buttonTextColor: Colors.white,
          //                             ),
          //                           ),
          //                         ],
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           );
          //         },
          //       );
          //     },
          //     icon: const Icon(
          //       Icons.delete,
          //       color: Colors.red,
          //     ),
          //   )
          // ],
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Form(
              key: key,
              child: Column(
                children: [
                  const SizedBox(height: 10.0),
                  Visibility(
                    visible: showProgress,
                    child: const CircularProgressIndicator(
                      color: kMainColor,
                      strokeWidth: 5.0,
                    ),
                  ),

                  ///___________Name_____________________________
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid product Name';
                        }
                        // You can add more validation logic as needed
                        return null;
                      },
                      decoration: kInputDecoration.copyWith(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: lang.S.of(context).productName,
                        hintText: 'Enter product Name',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),

                  ///_______Category__________________________________
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      readOnly: true,
                      controller: categoryController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a category';
                        }
                        return null;
                      },
                      onTap: () async {
                        data = await const CategoryList(isFromProductList: false,).launch(context);
                        setState(() {
                          categoryController.text = data.categoryName.categoryName ?? '';
                          selectedCategory = data.categoryName;
                        });
                      },
                      decoration:  kInputDecoration.copyWith(
                        suffixIcon: const Icon(Icons.keyboard_arrow_down),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'Product Category',
                        hintText: 'Select Product Category',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(10.0),
                  //   child: Container(
                  //     height: 60.0,
                  //     width: MediaQuery.of(context).size.width,
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(5.0),
                  //       border: Border.all(color: kGreyTextColor),
                  //     ),
                  //     child: Row(
                  //       children: [
                  //         const SizedBox(
                  //           width: 10.0,
                  //         ),
                  //         Text(widget.productModel?.category?.categoryName ?? ''),
                  //         const Spacer(),
                  //         const Icon(Icons.keyboard_arrow_down),
                  //         const SizedBox(
                  //           width: 10.0,
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  ///________Size__Color_________________________
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            validator: (value) => null,
                            controller: sizeController,
                            decoration: kInputDecoration.copyWith(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: lang.S.of(context).size,
                              hintText: 'Enter Size',
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ).visible(widget.productModel!.size != null || data.variations.contains('Size')),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: colorController,
                            decoration: kInputDecoration.copyWith(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: lang.S.of(context).color,
                              hintText: 'Enter color',
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ).visible(widget.productModel!.color != null || data.variations.contains('Color')),
                    ],
                  ),

                  ///________Capacity_and_weight_____________________________
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: weightController,
                            decoration: kInputDecoration.copyWith(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: lang.S.of(context).weight,
                              hintText: 'Enter weight',
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ).visible(widget.productModel!.weight != null || data.variations.contains('Weight')),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: capacityController,
                            decoration: kInputDecoration.copyWith(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: lang.S.of(context).capacity,
                              hintText: 'Enter Capacity',
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ).visible(widget.productModel!.capacity != null || data.variations.contains('Capacity')),
                    ],
                  ),

                  ///___________Type______________________________________
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: typeController,
                      decoration: kInputDecoration.copyWith(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: lang.S.of(context).type,
                        hintText: 'Enter Type',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ).visible(widget.productModel!.type != null || data.variations.contains('Type')),

                  ///_______Brand__________________________________
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      readOnly: true,
                      controller: brandController,
                      validator: (value) {
                        return null;
                      },
                      onTap: () async {
                        selectedBrand = await const BrandsList(isFromProductList: false,).launch(context);
                        setState(() {
                          brandController.text = selectedBrand?.brandName ?? '';
                        });
                      },
                      decoration:  kInputDecoration.copyWith(
                        suffixIcon: Icon(Icons.keyboard_arrow_down),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'Product Brand',
                        hintText: 'Select a brand',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  ///__________Code__________________________
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: AppTextField(
                            readOnly: true,
                            controller: productCodeController,
                            textFieldType: TextFieldType.NAME,
                            decoration: kInputDecoration.copyWith(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: lang.S.of(context).productCode,
                              hintText: widget.productModel!.productCode,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            height: 60.0,
                            width: 100.0,
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: kGreyTextColor),
                            ),
                            child: const Image(
                              image: AssetImage('images/barcode.png'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  ///_____________Stock__&_Unit__________________________
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            readOnly: true,
                            controller: productStockController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter a valid stock';
                              }
                              return null;
                            },
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                            keyboardType: TextInputType.number,
                            decoration: kInputDecoration.copyWith(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: lang.S.of(context).stock,
                              hintText: 'Enter stock',
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            readOnly: true,
                            controller: productUnitController,
                            validator: (value) {
                              return null;
                            },
                            onTap: () async {
                              selectedUnit = await const UnitList(isFromProductList: false,).launch(context);
                              setState(() {
                                productUnitController.text = selectedUnit?.unitName ?? '';
                              });
                            },
                            decoration: kInputDecoration.copyWith(
                              suffixIcon: Icon(Icons.keyboard_arrow_down),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: 'Product Unit',
                              hintText: 'Select Product Unit',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  ///_________Purchase_price__&&______mrp_____________________
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: purchasePriceController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a valid purchase price';
                              }
                              // You can add more validation logic as needed
                              return null;
                            },
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                            keyboardType: TextInputType.number,
                            decoration: kInputDecoration.copyWith(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: lang.S.of(context).purchasePrice,
                              hintText: 'Enter Purchase price',
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: salePriceController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a valid Sale price';
                              }
                              // You can add more validation logic as needed
                              return null;
                            },
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                            keyboardType: TextInputType.number,
                            decoration: kInputDecoration.copyWith(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: lang.S.of(context).mrp,
                              hintText: 'Enter Salting price',
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  ///_______-wholesalePrice_dealerprice_________________
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: wholeSalePriceController,
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                            keyboardType: TextInputType.number,
                            decoration: kInputDecoration.copyWith(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: lang.S.of(context).wholeSalePrice,
                              hintText: 'Enter wholesale price',
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: dealerPriceController,
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                            keyboardType: TextInputType.number,
                            decoration: kInputDecoration.copyWith(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: lang.S.of(context).dealerPrice,
                              hintText: 'Enter dealer price',
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: discountPriceController,
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                          keyboardType: TextInputType.number,
                          decoration: kInputDecoration.copyWith(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: lang.S.of(context).discount,
                            hintText: 'Enter discount',
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      )).visible(false),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: manufacturerController,
                            decoration: kInputDecoration.copyWith(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: lang.S.of(context).manufacturer,
                              hintText: 'Enter manufacturer name',
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              // ignore: sized_box_for_whitespace
                              child: Container(
                                height: 200.0,
                                width: MediaQuery.of(context).size.width - 80,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          pickedImage = await _picker.pickImage(source: ImageSource.gallery);
                                          setState(() {});
                                          Navigator.pop(context);
                                        },
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.photo_library_rounded,
                                              size: 60.0,
                                              color: kMainColor,
                                            ),
                                            Text(
                                              'Gallery',
                                              style: GoogleFonts.poppins(
                                                fontSize: 20.0,
                                                color: kMainColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 40.0,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          pickedImage = await _picker.pickImage(source: ImageSource.camera);
                                          setState(() {});
                                          Navigator.pop(context);
                                        },
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.camera,
                                              size: 60.0,
                                              color: kGreyTextColor,
                                            ),
                                            Text(
                                              lang.S.of(context).camera,
                                              style: GoogleFonts.poppins(
                                                fontSize: 20.0,
                                                color: kGreyTextColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54, width: 1),
                            borderRadius: const BorderRadius.all(Radius.circular(120)),
                            image: pickedImage == null
                                ? widget.productModel?.productPicture == null
                                    ? DecorationImage(
                                        image: AssetImage(noProductImageUrl),
                                        fit: BoxFit.cover,
                                      )
                                    : DecorationImage(
                                        image: NetworkImage('${APIConfig.domain}${widget.productModel?.productPicture ?? ''}'),
                                        fit: BoxFit.cover,
                                      )
                                : DecorationImage(
                                    image: FileImage(File(pickedImage!.path)),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: const BorderRadius.all(Radius.circular(120)),
                              color: kMainColor,
                            ),
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ButtonGlobalWithoutIcon(
                    buttontext: lang.S.of(context).saveNPublish,
                    buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
                    onPressed: () async {
                      if (key.currentState!.validate()) {
                        ProductRepo repo = ProductRepo();
                        repo.updateProduct(
                          ref: ref,
                          context: context,
                          productCode: productCodeController.text,
                          productId: widget.productModel!.id.toString(),
                          productName: nameController.text,
                          categoryId: selectedCategory?.id.toString(),
                          brandId: selectedBrand?.id.toString(),
                          unitId: selectedUnit?.id.toString(),
                          productSalePrice: salePriceController.text,
                          productPurchasePrice: purchasePriceController.text,
                          color: colorController.text.isEmptyOrNull ? null : colorController.text,
                          size: sizeController.text.isEmptyOrNull ? null : sizeController.text,
                          type: typeController.text.isEmptyOrNull ? null : typeController.text,
                          weight: weightController.text.isEmptyOrNull ? null : weightController.text,
                          capacity: capacityController.text.isEmptyOrNull ? null : capacityController.text,
                          productDealerPrice: dealerPriceController.text.isEmptyOrNull ? null : dealerPriceController.text,
                          productDiscount: discountPriceController.text.isEmptyOrNull ? null : discountPriceController.text,
                          productManufacturer: manufacturerController.text.isEmptyOrNull ? null : manufacturerController.text,
                          productWholeSalePrice: wholeSalePriceController.text.isEmptyOrNull ? null : wholeSalePriceController.text,
                          image: pickedImage == null ? null : File(pickedImage!.path),
                        );
                      }
                    },
                    buttonTextColor: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
