// ignore_for_file: unused_result

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_pos/Const/api_config.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/profile_provider.dart';
import '../../Provider/shop_category_provider.dart';
import '../../Repository/API/business_info_update_repo.dart';
import '../../constant.dart';
import '../../model/business_category_model.dart';
import '../../model/business_info_model.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key, required this.profile, required this.ref}) : super(key: key);

  final BusinessInformation profile;
  final WidgetRef ref;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = widget.profile.companyName ?? '';
    phoneController.text = widget.profile.phoneNumber ?? '';
    addressController.text = widget.profile.address ?? '';
  }

  int counter = 0;

  String dropdownValue = '';
  String companyName = 'nodata', phoneNumber = 'nodata';
  double progress = 0.0;
  int invoiceNumber = 0;
  bool showProgress = false;
  String profilePicture = 'nodata';
  num openingBalance = 0;
  num remainingShopBalance = 0;

  // ignore: prefer_typing_uninitialized_variables
  var dialogContext;
  final ImagePicker _picker = ImagePicker();
  XFile? pickedImage;
  File imageFile = File('No File');

  BusinessCategory? selectedBusinessCategory;

  DropdownButton<BusinessCategory> getCategory({required List<BusinessCategory> list}) {
    List<DropdownMenuItem<BusinessCategory>> dropDownItems = [];

    for (BusinessCategory category in list) {
      var item = DropdownMenuItem(
        value: category,
        child: Text(category.name),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      hint:  Text(lang.S.of(context).selectBusinessCategory,
          //'Select Business Category'
      ),
      items: dropDownItems,
      value: selectedBusinessCategory,
      onChanged: (value) {
        setState(() {
          selectedBusinessCategory = value!;
        });
      },
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    counter++;
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          lang.S.of(context).updateProfile,
          style: GoogleFonts.poppins(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      bottomNavigationBar: ButtonGlobal(
        iconWidget: Icons.arrow_forward,
        buttontext: lang.S.of(context).continueButton,
        iconColor: Colors.white,
        buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            final businessRepository = BusinessUpdateRepository();
            final isProfileUpdated = await businessRepository.updateProfile(
                id: widget.profile.id.toString(),
                name: nameController.text,
                categoryId: selectedBusinessCategory!.id.toString(),
                address: addressController.text,
                image: pickedImage != null ? File(pickedImage!.path) : null,
                phone: phoneController.text);

            if (isProfileUpdated) {
              widget.ref.refresh(businessInfoProvider);
              EasyLoading.showSuccess(
                lang.S.of(context).dataSavedSuccessfully,
                  //'Data saved successfully.'
              );
              Navigator.pop(context);
            } else {
              EasyLoading.showError(
                lang.S.of(context).somethingIs,
                 // 'Something is '
              );
            }
          }
        },
      ),
      body: SingleChildScrollView(
        child: Consumer(builder: (context, ref, child) {
          final categoryList = ref.watch(businessCategoryProvider);

          return categoryList.when(data: (categoryList) {
            if (counter == 1) {
              for (var element in categoryList) {
                if (element.id == widget.profile.category!.id) {
                  selectedBusinessCategory = element;
                }
              }
            }

            return Center(
              child: Column(
                children: [
                  Padding(
                    padding:  EdgeInsets.all(10.0),
                    child: Text(
                      lang.S.of(context).updateYourProfile,
                     // "Update your profile to connect your customer with better impression",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: kGreyTextColor,
                        fontSize: 15.0,
                      ),
                    ),
                  ),

                  ///__________Image_section________________________________________
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

                                          setState(() {
                                            imageFile = File(pickedImage!.path);
                                          });

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
                                             // 'Gallery',
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
                                          setState(() {
                                            imageFile = File(pickedImage!.path);
                                          });
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
                                             // 'Camera',
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
                                ? widget.profile.pictureUrl == null
                                    ? const DecorationImage(
                                        image: AssetImage('images/no_shop_image.png'),
                                        fit: BoxFit.cover,
                                      )
                                    : DecorationImage(
                                        image: NetworkImage(APIConfig.domain + widget.profile.pictureUrl.toString()),
                                        fit: BoxFit.cover,
                                      )
                                : DecorationImage(
                                    image: FileImage(imageFile),
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
                  const SizedBox(height: 20.0),

                  ///________Category_______________________________________________
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: 60.0,
                      child: FormField(
                        builder: (FormFieldState<dynamic> field) {
                          return InputDecorator(
                            decoration: kInputDecoration.copyWith(
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                labelText: lang.S.of(context).businessCat,
                                labelStyle: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                ),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
                            child: DropdownButtonHideUnderline(child: getCategory(list: categoryList)),
                          );
                        },
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: AppTextField(
                            controller: nameController, // Optional
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                //return 'Please enter a valid business name';
                                return lang.S.of(context).pleaseEnterAValidBusinessName;
                              }
                              return null;
                            },
                            textFieldType: TextFieldType.NAME,
                            decoration: kInputDecoration.copyWith(
                              labelText: lang.S.of(context).businessName,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            height: 60.0,
                            child: AppTextField(
                              controller: phoneController,
                              validator: (value) {
                                return null;
                              },
                              textFieldType: TextFieldType.PHONE,
                              decoration: kInputDecoration.copyWith(
                                labelText: lang.S.of(context).phone,
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: AppTextField(
                            controller: addressController,
                            validator: (value) {
                              return null;
                            },
                            textFieldType: TextFieldType.NAME,
                            decoration: kInputDecoration.copyWith(
                              labelText: lang.S.of(context).address,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }, error: (e, stack) {
            return Center(
              child: Text(e.toString()),
            );
          }, loading: () {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });
        }),
      ),
    );
  }
}
