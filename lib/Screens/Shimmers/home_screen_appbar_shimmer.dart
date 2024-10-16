import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreenAppBarShimmer extends StatelessWidget {
  const HomeScreenAppBarShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Row(
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 20,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 15,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.white,
                  ),
                )
              ],
            ),
            const Spacer(),
            Container(
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
              ),
            ),
          ],
        ));
  }
}
