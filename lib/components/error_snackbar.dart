import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'app_properties.dart';

class InputComponent {
  static void showErrorDialogBox(BuildContext context, dynamic message, dynamic title) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 16,
      child: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.black87, // Background color
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$title',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Error color
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            Text(
              '$message',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black, backgroundColor: Colors.white, // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.0),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


  static void showWarningSnackBar(BuildContext context, dynamic message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$message',
          style: TextStyle(
            color: Colors.black, // Text color
            fontSize: 16.0, // Font size
            fontWeight: FontWeight.bold, // Font weight
          ),
        ),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.white, // Background color
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.black, // Action button text color
          onPressed: () {
            ScaffoldMessenger.of(context)
                .hideCurrentSnackBar(); // Hide the snackbar
          },
        ),
        behavior: SnackBarBehavior.floating, // Floating snackbar
        margin: EdgeInsets.all(16.0), // Margin around snackbar
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Rounded corners
        ),
      ),
    );
  }

 static void showQrCodeDialog(BuildContext context, String roundName, int attendanceId) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 16,
        child: Container(
          padding: EdgeInsets.all(16.0),
          color: CardColor,
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'QR Code for $roundName',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: TextColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: QrImageView(
                      data: attendanceId.toString(),
                      version: QrVersions.auto,
                      size: 200,
                      gapless: false,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black, backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  
  
}
