import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:yccetpc/components/route.dart';
import 'package:yccetpc/screen/SignUP/coordinator_login.dart';
import 'package:yccetpc/screen/SignUP/forget_password.dart';

import '../../components/app_properties.dart';
import '../../model/user.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
              Image.asset(
                'assets/images/y.png',
                width: 150, // Adjust size as needed
                height: 150, // Adjust size as needed
              ),
             
              const SizedBox(height: 10),
              Text(
                'Sign in',
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
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Password Input Field
                    TextFormField(
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      maxLines: 1,
                      obscureText: true,
                      style: TextStyle(color: TextColor),
                      cursorColor: TextColor,
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        hintStyle: TextStyle(color: HintColor),
                        prefixIcon: Icon(Icons.lock, color: HintColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Sign In Button
                    SizedBox(
                      width: double.infinity, // Makes the button span the full width of its container
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // Button color
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                              )
                            : const Text(
                                'Sign in',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Forget Password Button
                    TextButton(
                      child: Text("Forget Password", style: TextStyle(color: TextColor)),
                      onPressed: () {
                        RouterClass.AddScreen(context, ForgetPassword());
                      },
                    ),
                    const SizedBox(height: 10),

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
                            RouterClass.AddScreen(context, CoLoginPage());
                          },
                          child: const Text(
                            'Click here',
                            style: TextStyle(color:Color.fromARGB(255, 75, 90, 102),fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await User.login(_emailController.text, _passwordController.text, context);

      setState(() {
        _isLoading = false;
      });
    }
  }
}
