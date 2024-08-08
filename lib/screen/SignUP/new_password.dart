import 'package:flutter/material.dart';
import 'package:yccetpc/model/user.dart';

import '../../components/app_properties.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({Key? key}) : super(key: key);

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? passwordError;
  String? confirmPasswordError;
  bool _isLoading = false;

  bool isStrongPassword(String password) {
    if (password.length < 8) {
      return false;
    }

    int uppercaseCount = password.replaceAll(RegExp(r'[^A-Z]'), '').length;
    if (uppercaseCount < 2) {
      return false;
    }

    int numericCount = password.replaceAll(RegExp(r'[^0-9]'), '').length;
    if (numericCount < 3) {
      return false;
    }

    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return false;
    }

    return true;
  }

  void _validatePassword(String value) {
    if (isStrongPassword(value)) {
      setState(() {
        passwordError = null;
      });
    } else {
      setState(() {
        passwordError = "Please enter a strong password";
      });
    }
  }

  void _validateConfirmPassword(String value) {
    if (value == _passwordController.text) {
      setState(() {
        confirmPasswordError = null;
      });
    } else {
      setState(() {
        confirmPasswordError = "Passwords do not match";
      });
    }
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
              'TPC YCCE',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
                color: TextColor,
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _passwordController,
                    onChanged: _validatePassword,
                    validator: (value) => isStrongPassword(value!)
                        ? null
                        : "Please enter a strong password",
                    maxLines: 1,
                    style: TextStyle(color: TextColor),
                    obscureText: true,
                    cursorColor: TextColor,
                    decoration: InputDecoration(
                      hintText: 'Enter your new password',
                      hintStyle: TextStyle(color: HintColor),
                      prefixIcon: Icon(Icons.email, color: HintColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      errorText: passwordError,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _confirmPasswordController,
                    onChanged: _validateConfirmPassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
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
                      hintText: 'Confirm your password',
                      hintStyle: TextStyle(color: HintColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      errorText: confirmPasswordError,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            setState(() {
                              _isLoading = true;
                            });
                            if (_formKey.currentState!.validate()) {
                              await User.update_password(
                                  _passwordController.text, context);
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Text(
                            'Sign in',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: 20,
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
