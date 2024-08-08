import 'package:flutter/material.dart';
import 'package:yccetpc/components/app_properties.dart';
import 'package:email_validator/email_validator.dart';

import '../../model/user.dart';

class ForgetPassword extends StatefulWidget {
  @override
  State<ForgetPassword> createState() => __ForgetPasswordState();
}

class __ForgetPasswordState extends State<ForgetPassword> {
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
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Forget Password',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 30, color: TextColor),
            ),
            const SizedBox(
              height: 60,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
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
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  if (isOtpVisible)
                    Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
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
                            prefixIcon: Icon(
                              Icons.lock,
                              color: HintColor,
                            ),
                            hintText: 'Enter OTP',
                            hintStyle: TextStyle(color: HintColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
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
                      padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                    ),
                    child: isSubmitting
                        ? CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text(
                            'Submit',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'TPC CO-ordinator?',
                        style: TextStyle(color: TextColor),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                          //         const RegisterPage(title: 'Register UI'),
                          //   ),
                          // );
                        },
                        child: const Text('Click here'),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
