import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const ProposalApp());
}

class ProposalApp extends StatelessWidget {
  const ProposalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Proposal System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}