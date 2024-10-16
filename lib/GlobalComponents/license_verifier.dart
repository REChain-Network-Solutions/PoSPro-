import 'package:flutter/material.dart';

void showLicense({required BuildContext context}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Container(
            height: 180.0,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: const Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        'Please Check Your Purchase Code',
                        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Your purchase code is not valid. Please buy our product from envato to get a new purchase code',
                        maxLines: 6,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
