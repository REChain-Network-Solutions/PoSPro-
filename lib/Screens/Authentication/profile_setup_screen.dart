import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/shop_category_provider.dart';
import '../../Repository/API/business_setup_repo.dart';
import '../../constant.dart';
import '../../model/business_category_model.dart';
import '../../model/lalnguage_model.dart';

class ProfileSetup extends StatefulWidget {
  const ProfileSetup({Key? key}) : super(key: key);

  @override
  State<ProfileSetup> createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _pulseController;

  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  // Language? selectedLanguage;
  BusinessCategory? selectedBusinessCategory;
  List<Language> language = [];

  final ImagePicker _picker = ImagePicker();
  XFile? pickedImage;
  TextEditingController addressController = TextEditingController();
  TextEditingController openingBalanceController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    // _loadLanguages();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _fadeController.forward();
    _slideController.forward();
    _scaleController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  // void _loadLanguages() async {
  //   for (var element in languageData) {
  //     final data = Language.fromJson(element);
  //
  //     language.add(data);
  //     if (data.code == "en") {
  //       selectedLanguage = data;
  //     }
  //   }
  // }

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
      hint: Text(lang.S.of(context).selectBusinessCategory
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

  // DropdownButton<Language> getLanguage() {
  //   List<DropdownMenuItem<Language>> dropDownLangItems = [];
  //   for (Language lang in language) {
  //     var item = DropdownMenuItem(
  //       value: lang,
  //       child: Text(lang.name),
  //     );
  //     dropDownLangItems.add(item);
  //   }
  //   return DropdownButton(
  //     items: dropDownLangItems,
  //     value: lang,
  //     onChanged: (value) {
  //       setState(() {
  //         selectedLanguage = value!;
  //       });
  //     },
  //   );
  // }

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Consumer(builder: (context, ref, __) {
        final businessCategoryList = ref.watch(businessCategoryProvider);

        return businessCategoryList.when(data: (categoryList) {
          return Scaffold(
            backgroundColor: kWhite,
            body: CustomScrollView(
              slivers: [
                _buildSliverAppBar(),
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                              _buildProfileImageSection(),
                              const SizedBox(height: 30),
                              _buildBusinessCategorySection(categoryList),
                              const SizedBox(height: 20),
                              _buildBusinessNameSection(),
                              const SizedBox(height: 20),
                              _buildPhoneSection(),
                              const SizedBox(height: 20),
                              _buildAddressSection(),
                              const SizedBox(height: 20),
                              _buildOpeningBalanceSection(),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),
                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
            bottomNavigationBar: _buildBottomButton(),
          );
        }, error: (e, stack) {
          return _buildErrorView(e.toString());
        }, loading: () {
          return _buildLoadingView();
        });
      }),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      backgroundColor: kMainColor,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                kMainColor,
                kMainColor.withOpacity(0.8),
                kMainColor.withOpacity(0.6),
              ],
            ),
          ),
          child: Center(
            child: ScaleTransition(
              scale: _pulseAnimation,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.person_add,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          lang.S.of(context).setUpProfile,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      elevation: 0,
    );
  }

  Widget _buildProfileImageSection() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
        child: Column(
          children: [
            const Text(
              'Profile Picture',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: kMainColor,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => _showImagePickerDialog(),
                        child: Stack(
                          children: [
                            Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: pickedImage == null
                                    ? const DecorationImage(
                                        image: AssetImage('images/noImage.png'),
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
                                  shape: BoxShape.circle,
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
            const SizedBox(height: 16),
            Text(
              'Tap to change profile picture',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessCategorySection(List<BusinessCategory> categoryList) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Business Category',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: kMainColor,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
                          height: 60.0,
                          child: FormField(
                            builder: (FormFieldState<dynamic> field) {
                              return InputDecorator(
                  decoration: InputDecoration(
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    labelText: lang.S.of(context).businessCat,
                                    labelStyle: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      fontSize: 16.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(color: kMainColor, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                                child: DropdownButtonHideUnderline(child: getCategory(list: categoryList)),
                              );
                            },
                          ),
                        ),
        ],
      ),
    );
  }

  Widget _buildBusinessNameSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Business Name',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: kMainColor,
            ),
          ),
          const SizedBox(height: 12),
          AppTextField(
                          textFieldType: TextFieldType.NAME,
                          controller: nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return lang.S.of(context).pleaseEnterAValidBusinessName;
                            }
                            return null;
                          },
            decoration: InputDecoration(
                            labelText: lang.S.of(context).businessName,
                            hintText: lang.S.of(context).enterBusiness,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: kMainColor, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Phone Number',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: kMainColor,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
                          height: 60.0,
                          child: AppTextField(
                            controller: phoneController,
                            validator: (value) {
                              return null;
                            },
                            textFieldType: TextFieldType.PHONE,
              decoration: InputDecoration(
                              labelText: lang.S.of(context).phone,
                              hintText: lang.S.of(context).enterYourPhoneNumber,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: kMainColor, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey[50],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),
        ],
      ),
    );
  }

  Widget _buildAddressSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Company Address',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: kMainColor,
            ),
          ),
          const SizedBox(height: 12),
          AppTextField(
                          textFieldType: TextFieldType.ADDRESS,
                          controller: addressController,
            decoration: InputDecoration(
                            labelText: lang.S.of(context).companyAddress,
                            hintText: lang.S.of(context).enterFullAddress,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: kMainColor, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpeningBalanceSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Opening Balance',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: kMainColor,
            ),
          ),
          const SizedBox(height: 12),
          AppTextField(
                          validator: (value) {
                            return null;
                          },
            controller: openingBalanceController,
                          textFieldType: TextFieldType.PHONE,
            decoration: InputDecoration(
                            hintText: lang.S.of(context).enterOpeningBalance,
                            labelText: lang.S.of(context).openingBalance,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: kMainColor, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ButtonGlobal(
        iconWidget: Icons.arrow_forward,
        buttontext: lang.S.of(context).continueButton,
        iconColor: Colors.white,
        buttonDecoration: kButtonDecoration.copyWith(
          color: kMainColor,
          borderRadius: BorderRadius.circular(12),
        ),
        onPressed: () async {
          if (selectedBusinessCategory != null) {
            if (_formKey.currentState!.validate()) {
              try {
                BusinessSetupRepo businessSetupRepo = BusinessSetupRepo();
                await businessSetupRepo.businessSetup(
                  context: context,
                  name: nameController.text,
                  phone: phoneController.text,
                  address: addressController.text.isEmptyOrNull ? null : addressController.text,
                  categoryId: selectedBusinessCategory!.id.toString(),
                  image: pickedImage == null ? null : File(pickedImage!.path),
                  openingBalance: openingBalanceController.text.isEmptyOrNull ? null : openingBalanceController.text,
                );
              } catch (e) {
                EasyLoading.dismiss();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
              }
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select a Business Category')));
          }
        },
      ),
    );
  }

  Widget _buildImagePickerDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        height: 200.0,
        width: MediaQuery.of(context).size.width - 80,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Choose Image Source',
              style: GoogleFonts.poppins(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: kMainColor,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageSourceOption(
                  icon: Icons.photo_library_rounded,
                  label: lang.S.of(context).gallery,
                  onTap: () async {
                    pickedImage = await _picker.pickImage(source: ImageSource.gallery);
                    setState(() {});
                    Navigator.pop(context);
                  },
                ),
                _buildImageSourceOption(
                  icon: Icons.camera,
                  label: lang.S.of(context).camera,
                  onTap: () async {
                    pickedImage = await _picker.pickImage(source: ImageSource.camera);
                    setState(() {});
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: kMainColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              size: 40.0,
              color: kMainColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 16.0,
              color: kMainColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _buildImagePickerDialog();
      },
    );
  }

  Widget _buildErrorView(String error) {
    return Scaffold(
      backgroundColor: kWhite,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[400],
              ),
              const SizedBox(height: 16),
              Text(
                'Error Loading Categories',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[400],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
                    ],
                  ),
                ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Scaffold(
      backgroundColor: kWhite,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(kMainColor),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading Business Categories...',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
