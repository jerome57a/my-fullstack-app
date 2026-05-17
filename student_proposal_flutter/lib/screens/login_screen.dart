import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'student_dashboard.dart'; 
import 'teacher_dashboard.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleLogin() async {
    setState(() => _isLoading = true);
    final result = await ApiService.login(_emailController.text.trim(), _passwordController.text.trim());
    setState(() => _isLoading = false);

    if (result != null) {
      final user = result['user'];
      final String role = user['role'];
      
      if (role == 'student') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StudentDashboard(user: user)));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TeacherDashboard(user: user)));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login Failed. Check credentials."), backgroundColor: Colors.redAccent)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, 
            colors: [Color(0xFF1A237E), Color(0xFF3949AB)]
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 100),
            const Icon(Icons.directions_boat_filled, size: 80, color: Colors.white),
            const SizedBox(height: 10),
            const Text("BoaTrack", style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            const Text("Proposal System", style: TextStyle(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 50),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: const BoxDecoration(
                  color: Colors.white, 
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60))
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      _buildField(_emailController, "Email Address", Icons.email_outlined),
                      const SizedBox(height: 20),
                      _buildField(_passwordController, "Password", Icons.lock_outline, isPass: true),
                      const SizedBox(height: 40),
                      _isLoading 
                        ? const CircularProgressIndicator(color: Color(0xFF1A237E)) 
                        : SizedBox(
                            width: double.infinity, height: 55,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1A237E), 
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                              ),
                              onPressed: _handleLogin,
                              child: const Text("LOGIN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                            ),
                          ),
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen())),
                        child: RichText(
                          text: const TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                            children: [
                              TextSpan(
                                text: "Register here",
                                style: TextStyle(
                                  color: Color(0xFF3949AB), 
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String hint, IconData icon, {bool isPass = false}) {
    return TextField(
      controller: controller,
      obscureText: isPass,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF1A237E)),
        hintText: hint,
        filled: true, 
        fillColor: const Color(0xFFF5F7FB),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15), 
          borderSide: BorderSide.none
        ),
      ),
    );
  }
}