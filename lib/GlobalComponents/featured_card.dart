import 'package:flutter/material.dart';
import 'package:mobile_pos/Screens/Products/product_data.dart';

import '../constant.dart';
import '../currency.dart';

class FeaturedCard extends StatefulWidget {
  const FeaturedCard({
    Key? key,
    required this.product,
  }) : super(key: key);
  final Product product;

  @override
  // ignore: library_private_types_in_public_api
  _FeaturedCardState createState() => _FeaturedCardState();
}

class _FeaturedCardState extends State<FeaturedCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: GestureDetector(
        onTap: null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 240.0,
              width: 172.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      widget.product.images[0],
                      height: 148.0,
                      width: 124.0,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        widget.product.title.toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '$currency${widget.product.price.toString()}',
                        style: const TextStyle(color: kGreyTextColor, fontSize: 15.0),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: InkWell(
                          onTap: () {},
                          child: const Icon(
                            Icons.add_shopping_cart,
                            color: kMainColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
