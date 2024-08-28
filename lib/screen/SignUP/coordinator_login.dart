import 'package:flutter/material.dart';
import 'package:yccetpc/components/route.dart';
import 'package:yccetpc/model/coordinator.dart';
import 'package:yccetpc/screen/SignUP/login.dart';
import '../../components/app_properties.dart';

class CoLoginPage extends StatefulWidget {
  @override
  State<CoLoginPage> createState() => _CoLoginPageState();
}

class _CoLoginPageState extends State<CoLoginPage> {
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
            mainAxisSize: MainAxisSize.min, // Ensures Column is centered
            children: <Widget>[
              // Logo
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
                width: 120, // Adjust size as needed
                height: 120, // Adjust size as needed
              ),
              const SizedBox(height: 20),
              Text(
                'Co-Sign In',
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
                    // ID Input Field
                    TextFormField(
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your ID';
                        }
                        return null;
                      },
                      maxLines: 1,
                      style: TextStyle(color: TextColor),
                      cursorColor: TextColor,
                      decoration: InputDecoration(
                        hintText: 'Enter your ID',
                        hintStyle: TextStyle(color: HintColor),
                        prefixIcon: Icon(Icons.email, color: HintColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
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
                        prefixIcon: Icon(Icons.lock, color: HintColor),
                        hintText: 'Enter your password',
                        hintStyle: TextStyle(color: HintColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Sign In Button
                    SizedBox(
                      width: double.infinity, // Makes the button span the full width
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  await Coordinator.login(
                                      _emailController.text,
                                      _passwordController.text,
                                      context);
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // Button color
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
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
                    // Student Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Student Login?',
                          style: TextStyle(color: TextColor),
                        ),
                        TextButton(
                          onPressed: () {
                            RouterClass.AddScreen(context, LoginPage());
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
    );
  }
}
