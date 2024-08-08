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
  var rememberValue = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

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
              'Sign in',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 40, color: TextColor),
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
                  const SizedBox(
                    height: 20,
                  ),
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
                      prefixIcon: Icon(
                        Icons.lock,
                        color: HintColor,
                      ),
                      hintText: 'Enter your password',
                      hintStyle: TextStyle(color: HintColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text(
                            'Sign in',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  Container(
                    child: TextButton(
                      child: Text("Forget Password"),
                      onPressed: () {
                        RouterClass.AddScreen(context, ForgetPassword());
                      },
                    ),
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
                          RouterClass.AddScreen(context, CoLoginPage());
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
