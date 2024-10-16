import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:mobile_pos/Const/api_config.dart';
import 'package:mobile_pos/Provider/product_provider.dart';
import 'package:mobile_pos/Screens/Products/brands_list.dart';
import 'package:mobile_pos/Screens/Products/category_list_screen.dart';
import 'package:mobile_pos/Screens/Products/unit_list.dart';
import 'package:mobile_pos/Screens/Products/update_product.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import '../../constant.dart';
import '../../currency.dart';
import 'Repo/product_repo.dart';
import 'Widgets/widgets.dart';

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, __) {
        final providerData = ref.watch(productProvider);
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: kWhite,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            title: Text(
              lang.S.of(context).productList,
              style: GoogleFonts.poppins(
                color: Colors.black,
              ),
            ),
            actions: [
              PopupMenuButton<int>(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CategoryList(
                                    isFromProductList: true,
                                  )));
                    },
                    child: Row(
                      children: [
                        const Icon(
                          IconlyBold.category,
                          color: kGreyTextColor,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Product Category",
                          style: gTextStyle.copyWith(color: kGreyTextColor),
                        )
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BrandsList(
                                    isFromProductList: true,
                                  )));
                    },
                    child: Row(
                      children: [
                        const Icon(
                          IconlyBold.bookmark,
                          color: kGreyTextColor,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Brand",
                          style: gTextStyle.copyWith(color: kGreyTextColor),
                        )
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UnitList(
                                    isFromProductList: true,
                                  )));
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.scale,
                          color: kGreyTextColor,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Product Unit",
                          style: gTextStyle.copyWith(color: kGreyTextColor),
                        )
                      ],
                    ),
                  ),
                ],
                offset: const Offset(0, 40),
                color: kWhite,
                padding: EdgeInsets.zero,
                elevation: 2,
              ),
            ],
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
              backgroundColor: kMainColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
              onPressed: () {
                Navigator.pushNamed(context, '/AddProducts');
              },
              child: const Icon(
                Icons.add,
                color: kWhite,
              )),
          body: SingleChildScrollView(
            child: providerData.when(data: (products) {
              return products.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      itemBuilder: (_, i) {
                        return ListTile(
                          // visualDensity: VisualDensity(horizontal: -4,vertical: -4),
                          contentPadding: const EdgeInsets.only(left: 16),
                          // onTap: () {
                          //   Navigator.push(context, MaterialPageRoute(builder: (context)=>const ProductDetails()));
                          // },
                          leading: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(90)),
                              image: products[i].productPicture == null
                                  ? DecorationImage(
                                      image: AssetImage(
                                        noProductImageUrl,
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                  : DecorationImage(
                                      image: NetworkImage(
                                        '${APIConfig.domain}${products[i].productPicture!}',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            // child: CachedNetworkImage(
                            //   imageUrl: products[i].productPicture,
                            //   placeholder: (context, url) => const SizedBox(height: 50, width: 50, ),
                            //   errorWidget: (context, url, error) => const Icon(Icons.error),
                            //   fit: BoxFit.cover,
                            // ),
                          ),
                          title: Text(products[i].productName ?? ''),
                          subtitle: Text("${lang.S.of(context).stock} : ${products[i].productStock}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "$currency ${products[i].productSalePrice}",
                                style: const TextStyle(fontSize: 18),
                              ),
                              PopupMenuButton<int>(
                                itemBuilder: (context) => [
                                  // popupmenu item 1
                                  PopupMenuItem(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => UpdateProduct(
                                                    productModel: products[i],
                                                  )));
                                    },
                                    value: 1,
                                    // row has two child icon and text.
                                    child: Row(
                                      children: [
                                        const Icon(
                                          IconlyBold.edit,
                                          color: kGreyTextColor,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          "Edit",
                                          style: gTextStyle.copyWith(color: kGreyTextColor),
                                        )
                                      ],
                                    ),
                                  ),

                                  ///_________Delete___________________________________
                                  PopupMenuItem(
                                    onTap: () async {
                                      bool confirmDelete = await showDeleteAlert(context: context, itemsName: 'product');

                                      if (confirmDelete) {
                                        EasyLoading.show(status: 'Deleting....');
                                        ProductRepo productRepo = ProductRepo();
                                        await productRepo.deleteProduct(id: products[i].id.toString(), context: context, ref: ref);
                                      }
                                    },
                                    value: 1,
                                    // row has two child icon and text.
                                    child: Row(
                                      children: [
                                        const Icon(
                                          IconlyBold.delete,
                                          color: kGreyTextColor,
                                        ),
                                        SizedBox(
                                          // sized box with width 10
                                          width: 10,
                                        ),
                                        Text(
                                          "Delete",
                                          style: gTextStyle.copyWith(color: kGreyTextColor),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                                offset: const Offset(0, 40),
                                color: kWhite,
                                padding: EdgeInsets.zero,
                                elevation: 2,
                              ),
                            ],
                          ),
                        );
                      })
                  : Center(
                      child: Text(
                        lang.S.of(context).addProduct,
                        maxLines: 2,
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                    );
            }, error: (e, stack) {
              return Text(e.toString());
            }, loading: () {
              return const Center(child: CircularProgressIndicator());
            }),
          ),
          // bottomNavigationBar: ButtonGlobal(
          //   iconWidget: Icons.add,
          //   buttontext: lang.S.of(context).addNewProduct,
          //   iconColor: Colors.white,
          //   buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
          //   onPressed: () {
          //     Navigator.pushNamed(context, '/AddProducts');
          //   },
          // ),
        );
      },
    );
  }
}
