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
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                  width: 120,
                  height: 120,
                ),
                const SizedBox(height: 20),
                Text(
                  'Reset Password',
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
                    children: [
                      // Password Input Field
                      TextFormField(
                        controller: _passwordController,
                        onChanged: _validatePassword,
                        validator: (value) => isStrongPassword(value!)
                            ? null
                            : "Please enter a strong password",
                        maxLines: 1,
                        style: TextStyle(color: Colors.black),
                        obscureText: true,
                        cursorColor: TextColor,
                        decoration: InputDecoration(
                          hintText: 'Enter your new password',
                          hintStyle: TextStyle(color: HintColor),
                          prefixIcon: Icon(Icons.lock, color: HintColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          errorText: passwordError,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Confirm Password Input Field
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
                        style: TextStyle(color: Colors.black),
                        cursorColor: TextColor,
                        decoration: InputDecoration(
                          hintText: 'Confirm your password',
                          hintStyle: TextStyle(color: HintColor),
                          prefixIcon: Icon(Icons.lock, color: HintColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          errorText: confirmPasswordError,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
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
                            backgroundColor: Colors.white, // Background color
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 5, // Adds shadow to the button
                          ),
                          child: _isLoading
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                )
                              : Text(
                                  'Update Password',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
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
