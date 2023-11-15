import 'package:agencia_viagens/pages/home.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SQLITE',
      theme: ThemeData.dark(
          //primarySwatch: Colors.blue,
          ),

      //textTheme: GoogleFonts.robotoTextTheme()),
      home: const MyHome(),
    );
  }
}
