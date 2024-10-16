import 'package:flutter/material.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

class SmsConfirmationPopup extends StatefulWidget {
  final String customerName;
  final String phoneNumber;
  final Function onSendSms;
  final VoidCallback onCancel;

  const SmsConfirmationPopup({Key? key,
    required this.customerName,
    required this.phoneNumber,
    required this.onSendSms,
    required this.onCancel,
  }) : super(key: key);

  @override
  _SmsConfirmationPopupState createState() => _SmsConfirmationPopupState();
}

class _SmsConfirmationPopupState extends State<SmsConfirmationPopup> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final scale = _animationController.value;
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Confirm SMS to ${widget.customerName}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8.0),
              Text(
                'An SMS will be sent to the following number: ${widget.phoneNumber}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: widget.onCancel,
                    child:  Text(
                      lang.S.of(context).cancel,
                        //'Cancel'
                    ),
                  ),
                  ElevatedButton(
                    style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(kMainColor)),
                    onPressed: () {
                      widget.onSendSms();
                      Navigator.pop(context);
                    },
                    child:  Text(
                      lang.S.of(context).sendSMS,
                     // 'Send SMS',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _animationController.forward();
  }
}
