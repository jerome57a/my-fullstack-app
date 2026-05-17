import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _selectedRole = 'student';

  void _handleRegister() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("All fields are required"), backgroundColor: Colors.orange));
      return;
    }

    bool success = await ApiService.register(name, email, password, _selectedRole);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Registration Successful!"), backgroundColor: Colors.green));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Registration Failed. Email might be taken."), backgroundColor: Colors.redAccent));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(elevation: 0, backgroundColor: Colors.transparent, iconTheme: const IconThemeData(color: Color(0xFF1A237E))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            const Icon(Icons.person_add_alt_1, size: 80, color: Color(0xFF1A237E)),
            const SizedBox(height: 15),
            const Text("Create Account", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
            const Text("Join BoaTrack today", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 40),
            _buildInput(_nameController, "Full Name", Icons.person_outline),
            const SizedBox(height: 15),
            _buildInput(_emailController, "Email Address", Icons.email_outlined),
            const SizedBox(height: 15),
            _buildInput(_passwordController, "Password", Icons.lock_outline, isPassword: true),
            const SizedBox(height: 25),
            const Align(alignment: Alignment.centerLeft, child: Text("I am a:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87))),
            const SizedBox(height: 10),
            Row(
              children: [
                _roleOption("student", Icons.school_outlined),
                const SizedBox(width: 15),
                _roleOption("teacher", Icons.co_present_outlined),
              ],
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity, height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A237E), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                onPressed: _handleRegister,
                child: const Text("REGISTER", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label, prefixIcon: Icon(icon, color: const Color(0xFF1A237E)),
        filled: true, fillColor: const Color(0xFFF5F7FB),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _roleOption(String role, IconData icon) {
    bool isSelected = _selectedRole == role;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedRole = role),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1A237E) : const Color(0xFFF5F7FB),
            borderRadius: BorderRadius.circular(15),
            border: isSelected ? null : Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? Colors.white : Colors.grey),
              const SizedBox(height: 5),
              Text(role.toUpperCase(), style: TextStyle(color: isSelected ? Colors.white : Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}