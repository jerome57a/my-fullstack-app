import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

class TeacherDashboard extends StatefulWidget {
  final Map<String, dynamic> user;
  const TeacherDashboard({super.key, required this.user});
  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  List<dynamic> _proposals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  void _fetch() async {
    setState(() => _isLoading = true);
    final data = await ApiService.getAllProposals();
    setState(() { _proposals = data; _isLoading = false; });
  }

  void _showReviewSheet(dynamic proposal) {
    final TextEditingController commentController = TextEditingController();
    showModalBottomSheet(
      context: context, 
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 25, right: 25, top: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Review Proposal", style: TextStyle(color: Colors.grey[600], fontSize: 14)),
            Text(proposal['title'] ?? 'No Title', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
            const SizedBox(height: 20),
            TextField(
              controller: commentController, maxLines: 3,
              decoration: InputDecoration(
                hintText: "Enter feedback for the student...",
                filled: true, fillColor: const Color(0xFFF5F7FB),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none)
              )
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _submit(proposal['id'], 'rejected', commentController.text),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), padding: const EdgeInsets.symmetric(vertical: 15)),
                    child: const Text("REJECT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  )
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _submit(proposal['id'], 'approved', commentController.text),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), padding: const EdgeInsets.symmetric(vertical: 15)),
                    child: const Text("APPROVE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  )
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _submit(int id, String status, String comment) async {
    await ApiService.updateProposalStatus(id, status, widget.user['id']);
    if (comment.isNotEmpty) await ApiService.addFeedback(id, widget.user['id'], comment);
    Navigator.pop(context);
    _fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text("Instructor Panel", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white, foregroundColor: const Color(0xFF1A237E), elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetch),
          IconButton(
            icon: const Icon(Icons.logout), 
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()))
          )
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: Color(0xFF1A237E))) 
        : _proposals.isEmpty 
          ? const Center(child: Text("No proposals to review.", style: TextStyle(color: Colors.grey)))
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _proposals.length,
              itemBuilder: (context, index) {
                final p = _proposals[index];
                
                // FALLBACK ADDED HERE:
                final studentName = p['fullname'] ?? 'Unknown Student'; 
                final projectTitle = p['title'] ?? 'Untitled Proposal';

                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(20),
                    title: Text(projectTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text("By: $studentName", style: TextStyle(color: Colors.grey[600])),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: const Color(0xFFF5F7FB), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.edit_document, color: Color(0xFF1A237E), size: 20),
                    ),
                    onTap: () => _showReviewSheet(p),
                  ),
                );
              },
            ),
    );
  }
}