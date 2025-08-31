// ignore_for_file: unused_result, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Screens/Products/Model/brands_model.dart' as brand;
import 'package:mobile_pos/Screens/Products/Model/unit_model.dart' as unit;
import 'package:mobile_pos/Screens/Products/Repo/product_repo.dart';
import 'package:mobile_pos/Screens/Products/brands_list.dart';
import 'package:mobile_pos/Screens/Products/category_list_screen.dart';
import 'package:mobile_pos/Screens/Products/unit_list.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';
import '../Home/home.dart';
import '../Home/home_screen.dart';
import 'Model/category_model.dart';

// ignore: must_be_immutable
class AddProduct extends StatefulWidget {
  AddProduct({Key? key, this.catName, this.unitsName, this.brandName}) : super(key: key);

  // ignore: prefer_typing_uninitialized_variables
  var catName;

  // ignore: prefer_typing_uninitialized_variables
  var unitsName;

  // ignore: prefer_typing_uninitialized_variables
  var brandName;

  @override
  // ignore: library_private_types_in_public_api
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  CategoryModel? selectedCategory;
  brand.Brand? selectedBrand;
  unit.Unit? selectedUnit;
  late String productName, productStock, productSalePrice, productPurchasePrice, productCode;

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

  final ImagePicker _picker = ImagePicker();
  XFile? pickedImage;
  List<String> codeList = [];
  String promoCodeHint = 'Enter Product Code';

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes = '';
    try {
      // Временно используем простой ввод для демонстрации
      // В реальном приложении здесь будет сканер штрих-кода
      barcodeScanRes = 'DEMO_BARCODE_123';
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;
    if (codeList.contains(barcodeScanRes)) {
      EasyLoading.showError('This Product Already added!');
    } else {
      if (barcodeScanRes.isNotEmpty && barcodeScanRes != 'Failed to get platform version.') {
        setState(() {
          productCodeController.text = barcodeScanRes;
          promoCodeHint = barcodeScanRes;
        });
      }
    }
  }

  GlobalKey<FormState> key = GlobalKey();
  GetCategoryAndVariationModel data = GetCategoryAndVariationModel(variations: [], categoryName: CategoryModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        surfaceTintColor: kWhite,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          lang.S.of(context).addNewProduct,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer(builder: (context, ref, __) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Form(
              key: key,
              child: Column(
                children: [
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
                      decoration: kInputDecoration.copyWith(
                        suffixIcon: Icon(Icons.keyboard_arrow_down),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'Product Category',
                        hintText: 'Select Product Category',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

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
                      ).visible(data.variations.contains('Size')),
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
                      ).visible(data.variations.contains('Color')),
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
                      ).visible(data.variations.contains('Weight')),
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
                      ).visible(data.variations.contains('Capacity')),
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
                  ).visible(data.variations.contains('Type')),

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
                      decoration: kInputDecoration.copyWith(
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
                          child: TextFormField(
                            controller: productCodeController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'product code is required';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                productCode = value;
                                promoCodeHint = value;
                              });
                            },
                            onFieldSubmitted: (value) {
                              if (codeList.contains(value)) {
                                EasyLoading.showError('This Product Already added!');
                                productCodeController.clear();
                              } else {
                                setState(() {
                                  productCode = value;
                                  promoCodeHint = value;
                                });
                              }
                            },
                            decoration: kInputDecoration.copyWith(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: lang.S.of(context).productCode,
                              hintText: promoCodeHint,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: GestureDetector(
                            onTap: () => scanBarcodeNormal(),
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
                  Column(
                    children: [
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

                                              Future.delayed(const Duration(milliseconds: 100), () {
                                                Navigator.pop(context);
                                              });
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
                                                  lang.S.of(context).gallery,
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
                                              Future.delayed(const Duration(milliseconds: 100), () {
                                                Navigator.pop(context);
                                              });
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
                                    ? DecorationImage(
                                        image: AssetImage(noProductImageUrl),
                                        fit: BoxFit.cover,
                                      )
                                    : DecorationImage(
                                        image: FileImage(File(pickedImage!.path)),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black54, width: 1),
                                borderRadius: const BorderRadius.all(Radius.circular(120)),
                                // image: DecorationImage(
                                //   image: FileImage(File(pickedImage!.path)),
                                //   fit: BoxFit.cover,
                                // ),
                              ),
                              // child: imageFile.path == 'No File' ? null : Image.file(imageFile),
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
                      const SizedBox(height: 10),
                    ],
                  ),
                  ButtonGlobalWithoutIcon(
                    buttontext: lang.S.of(context).saveNPublish,
                    buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
                    onPressed: () async {
                      if (key.currentState!.validate()) {
                        bool result = await InternetConnectionChecker().hasConnection;
                        if (result) {
                          ProductRepo product = ProductRepo();
                          EasyLoading.show(status: 'Adding..');
                          await product.addProduct(
                            ref: ref,
                            context: context,
                            productName: nameController.text,
                            categoryId: selectedCategory!.id.toString(),
                            brandId: selectedBrand?.id.toString(),
                            unitId: selectedUnit?.id.toString(),
                            productCode: productCodeController.text,
                            productStock: productStockController.text,
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
                        } else {
                          try {
                            EasyLoading.show(status: 'Loading...', dismissOnTap: false);
                            Future.delayed(const Duration(milliseconds: 100), () {
                              const Home().launch(context, isNewTask: true);
                            });
                          } catch (e) {
                            EasyLoading.dismiss();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                          }
                        }
                      }
                    },
                    buttonTextColor: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
