import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

import '../../constant.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          lang.S.of(context).notification,
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
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            NotificationCard(
              title: lang.S.of(context).purchaseAlarm,
              iconColor: Colors.orange,
              icons: Icons.alarm,
              time: 'June 23, 2021',
              description: lang.S.of(context).lorem,
              // 'Lorem ipsum dolor sit amet, consectetur adip gravi iscing elit. Ultricies gravida scelerisque arcu facilisis duis in.',
            ),
            NotificationCard(
              title: lang.S.of(context).purchaseConfirmed,
              iconColor: Colors.purple,
              icons: Icons.notifications_none_outlined,
              time: 'June 23, 2021',
              description:lang.S.of(context).lorem,
              // 'Lorem ipsum dolor sit amet, consectetur adip gravi iscing elit. Ultricies gravida scelerisque arcu facilisis duis in.',
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    Key? key,
    required this.icons,
    required this.title,
    required this.description,
    required this.time,
    required this.iconColor,
  }) : super(key: key);

  final IconData icons;
  final String title;
  final String description;
  final String time;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: iconColor.withOpacity(0.2),
                ),
                child: Center(
                  child: Icon(
                    icons,
                    color: iconColor,
                  ),
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
              Column(
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 18.0,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                time,
                style: GoogleFonts.poppins(
                  color: kGreyTextColor,
                  fontSize: 12.0,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 60.0),
            child: Text(
              description,
              style: GoogleFonts.poppins(
                color: kGreyTextColor,
                fontSize: 14.0,
              ),
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}
