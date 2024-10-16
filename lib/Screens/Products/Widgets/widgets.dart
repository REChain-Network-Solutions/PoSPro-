import 'package:flutter/material.dart';

Future<bool> showDeleteAlert({required String itemsName, required BuildContext context}) async {
  return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Confirmation'),
            content: Text('Are you sure you want to delete this $itemsName?\nRelated data will be deleted also.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(false); // Return false when Cancel is pressed
                },
              ),
              TextButton(
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.of(context).pop(true); // Return true when Delete is pressed
                },
              ),
            ],
          );
        },
      ) ??
      false; // In case the dialog is dismissed without any action
}
