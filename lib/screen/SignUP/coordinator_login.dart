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
              'Co-Sign In',
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
                      padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : const Text(
                            'Sign in',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
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
