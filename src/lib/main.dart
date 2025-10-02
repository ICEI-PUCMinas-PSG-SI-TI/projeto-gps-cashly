import 'package:flutter/material.dart';
import 'package:src/landing_page.dart';

void main()
{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget
{
  @override
  const MyApp({super.key});

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp
    (
      title: "Cashly",
      home: LandingPage(),
    );
  }
}