import 'package:flutter/material.dart';
import 'login_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
      
      appBar: AppBar
      (
        title: Center
        (
          child: Text
          (
            'Cashly',
            
            style: TextStyle
            (
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold
          
            ),
          ),
        ),
      ),
    );
  }
}