import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constant.dart';

class GlobalContainer extends StatelessWidget {
  final String title;
  final String image;
  final String subtitle;
  const GlobalContainer({Key? key, required this.title, required this.image, required this.subtitle}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: kWhite
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10,vertical: 2),
        horizontalTitleGap: 10,
        visualDensity: const VisualDensity(vertical: -4),
        leading: SvgPicture.asset(image,height: 40,width: 40,),
        title: Text(title,style: gTextStyle.copyWith(color: kGreyTextColor,fontSize: 14),maxLines: 1,overflow: TextOverflow.ellipsis,),
        subtitle: Text(subtitle,style: gTextStyle.copyWith(fontWeight: FontWeight.bold,color: kTitleColor),),
      ),
    );
  }
}
