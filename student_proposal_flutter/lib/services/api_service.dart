import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // 1. NO 'const' keyword here!
  // 2. Put your real starting IP here, not the XX placeholder.
  static String baseUrl = "http://10.210.2.51:3000/api"; 

  // This variable will hold our JWT Token once we login
  static String? token;

  // ==========================================
  // 1. AUTHENTICATION
  // ==========================================

  static Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email, 
          "password": password
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        token = data['token']; // Save token for future secure requests
        return data;
      }
      return null;
    } catch (e) {
      print("Login Error: $e");
      return null;
    }
  }

  static Future<bool> register(String fullname, String email, String password, String role) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "fullname": fullname,
          "email": email,
          "password": password,
          "role": role,
        }),
      );
      return response.statusCode == 201; // 201 means "Created" in the backend
    } catch (e) {
      print("Registration Error: $e");
      return false;
    }
  }

  // ==========================================
  // 2. STUDENT ACTIONS
  // ==========================================

  static Future<bool> submitProposal(int userId, String title, String description) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/proposals/submit'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "user_id": userId,
          "title": title,
          "description": description,
        }),
      );
      return response.statusCode == 201;
    } catch (e) {
      print("Submit Proposal Error: $e");
      return false;
    }
  }

  static Future<List<dynamic>> getStudentProposals(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/proposals/user/$userId'),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      print("Error fetching student proposals: $e");
      return [];
    }
  }

  // ==========================================
  // 3. TEACHER ACTIONS
  // ==========================================

  static Future<List<dynamic>> getAllProposals() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/proposals/all'),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      print("Error fetching all proposals: $e");
      return [];
    }
  }

  static Future<bool> updateProposalStatus(int proposalId, String status, int teacherId) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/proposals/status/$proposalId'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "status": status,
          "teacher_id": teacherId
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error updating status: $e");
      return false;
    }
  }

  static Future<bool> addFeedback(int proposalId, int teacherId, String comment) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/feedback/add'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "proposal_id": proposalId,
          "teacher_id": teacherId,
          "comment": comment,
        }),
      );
      return response.statusCode == 201;
    } catch (e) {
      print("Error adding feedback: $e");
      return false;
    }
  }

  // ==========================================
  // 4. SHARED ACTIONS (Both Student & Teacher)
  // ==========================================

  static Future<List<dynamic>> getFeedback(int proposalId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/feedback/$proposalId'),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      print("Error fetching feedback: $e");
      return [];
    }
  }
}