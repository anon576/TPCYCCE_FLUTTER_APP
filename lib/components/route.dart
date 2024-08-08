import 'package:flutter/material.dart';

class RouterClass{
 
 static void AddScreen(context,Widget screen){
   Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
 }

 static void ReplaceScreen(context,String screen){
  Navigator.pushReplacementNamed(context, screen);
 }

}