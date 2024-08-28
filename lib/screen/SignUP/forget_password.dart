import 'package:flutter/material.dart';
import 'package:yccetpc/components/app_properties.dart';
import 'package:email_validator/email_validator.dart';
import '../../model/user.dart';

class ForgetPassword extends StatefulWidget {
  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool isOtpVisible = false;
  bool isEmailSubmitted = false;
  bool isSubmitting = false;

  Future<bool> submitEmail(String email) {
    // Simulate sending email to server and getting response
    return Future.delayed(
        Duration(seconds: 2), () => true); // Simulated response
  }

  Future<bool> submitOTP(String otp) {
    // Simulate sending OTP to server and getting response
    return Future.delayed(
        Duration(seconds: 2), () => otp == '1234'); // Simulated response
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(maxWidth: 600), // Max width for larger screens
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min, // To ensure column takes minimum space
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                  const SizedBox(height: 20),
              Text(
                'Yashwant',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 48,
                  color: TextColor,
                ),
              ),
                const SizedBox(height: 20),
                Image.asset(
                  'assets/images/y.png',
                  width: 120, // Adjust size as needed
                  height: 120, // Adjust size as needed
                ),
                const SizedBox(height: 20),
                Text(
                  'Forget Password',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                    color: TextColor,
                  ),
                ),
                const SizedBox(height: 40),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Email Input Field
                      TextFormField(
                        controller: _emailController,
                        validator: (value) => EmailValidator.validate(value!)
                            ? null
                            : "Please enter a valid email",
                        maxLines: 1,
                        style: TextStyle(color: TextColor),
                        cursorColor: TextColor,
                        decoration: InputDecoration(
                          hintText: 'Enter your email',
                          hintStyle: TextStyle(color: HintColor),
                          prefixIcon: Icon(Icons.email, color: HintColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        ),
                      ),
                      if (isOtpVisible)
                        Column(
                          children: [
                            const SizedBox(height: 20),
                            // OTP Input Field
                            TextFormField(
                              controller: _otpController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter OTP';
                                }
                                return null;
                              },
                              maxLines: 1,
                              obscureText: true,
                              style: TextStyle(color: TextColor),
                              cursorColor: TextColor,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock, color: HintColor),
                                hintText: 'Enter OTP',
                                hintStyle: TextStyle(color: HintColor),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 20),
                      // Submit Button
                      SizedBox(
                        width: double.infinity, // Makes the button span the full width
                        child: ElevatedButton(
                          onPressed: () async {
                            if (!isEmailSubmitted) {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  isSubmitting = true;
                                });
                                bool response = await User.forget_password(
                                    _emailController.text, context);
                                if (response) {
                                  setState(() {
                                    isEmailSubmitted = true;
                                    isSubmitting = false;
                                    isOtpVisible = true;
                                  });
                                } else {
                                  setState(() {
                                    isSubmitting = false;
                                  });
                                }
                              }
                            } else {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  int otp = int.parse(_otpController.text);
                                  setState(() {
                                    isSubmitting = true;
                                  });
                                  User.check_otp(otp, context);
                                  setState(() {
                                    isSubmitting = false;
                                  });
                                } catch (e) {
                                  print('Error parsing OTP: $e');
                                  setState(() {
                                    isSubmitting = false;
                                  });
                                }
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // Button color
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isSubmitting
                              ? CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.black),
                                )
                              : const Text(
                                  'Submit',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Coordinator Login Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'TPC CO-ordinator?',
                            style: TextStyle(color: TextColor),
                          ),
                          TextButton(
                            onPressed: () {
                              // Navigate to coordinator login page
                            },
                            child: const Text(
                              'Click here',
                              style: TextStyle(
                               color: Color.fromARGB(255, 75, 90, 102),
                                fontWeight: FontWeight.bold,
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
        ),
      ),
    );
  }
}
