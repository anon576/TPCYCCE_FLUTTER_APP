import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class InputComponent{

static void showErrorDialogBox(BuildContext context,dynamic test,dynamic test2){
   showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title:  Text('$test2'),
                content: Text('$test'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
}
   static void showWarningSnackBar(BuildContext context,dynamic test) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$test'),
        duration: Duration(seconds: 2),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            ScaffoldMessenger.of(context)
                .hideCurrentSnackBar(); // Hide the snackbar
          },
        ),
      ),
    );
  }

  static  bool Validate(String email) {
    bool _isValid = EmailValidator.validate(email);
    return _isValid;
  }
}