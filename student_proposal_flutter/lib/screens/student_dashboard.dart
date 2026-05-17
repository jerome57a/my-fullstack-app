import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

class StudentDashboard extends StatefulWidget {
  final Map<String, dynamic> user;
  const StudentDashboard({super.key, required this.user});
  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  List<dynamic> _proposals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    setState(() => _isLoading = true);
    final data = await ApiService.getStudentProposals(widget.user['id']);
    setState(() { _proposals = data; _isLoading = false; });
  }

  Color _getStatusColor(String status) {
    if (status == 'approved') return Colors.green;
    if (status == 'rejected') return Colors.red;
    return Colors.orange;
  }

  void _viewFeedback(int proposalId) async {
    final feedback = await ApiService.getFeedback(proposalId);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Teacher Feedback", style: TextStyle(fontWeight: FontWeight.bold)),
        content: feedback.isEmpty 
          ? const Text("No feedback has been added yet.") 
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: feedback.map((f) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
                child: Text('"${f['comment']}"', style: const TextStyle(fontStyle: FontStyle.italic)),
              )).toList(),
            ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close", style: TextStyle(color: Color(0xFF1A237E))))],
      ),
    );
  }

  // NEW: Method to show the submission form
  void _showAddProposalDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the sheet to move up when the keyboard appears
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => Padding(
        // The bottom padding ensures the keyboard doesn't cover the text fields
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom, 
          left: 25, right: 25, top: 30
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Submit New Proposal", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
            const SizedBox(height: 20),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Project Title",
                filled: true, fillColor: const Color(0xFFF5F7FB),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none)
              )
            ),
            const SizedBox(height: 15),
            TextField(
              controller: descController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Project Description",
                alignLabelWithHint: true,
                filled: true, fillColor: const Color(0xFFF5F7FB),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none)
              )
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E), 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                ),
                onPressed: () async {
                  // 1. Check if fields are empty
                  if (titleController.text.trim().isEmpty || descController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please fill in both fields"), backgroundColor: Colors.orange)
                    );
                    return;
                  }

                  // 2. Close the bottom sheet
                  Navigator.pop(context);
                  
                  // 3. Show loading screen while submitting
                  setState(() => _isLoading = true);

                  // 4. Send to database
                  bool success = await ApiService.submitProposal(
                    widget.user['id'], 
                    titleController.text.trim(), 
                    descController.text.trim()
                  );

                  // 5. Handle the result
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Proposal Submitted Successfully!"), backgroundColor: Colors.green)
                    );
                    _loadData(); // Refresh the list to show the new proposal
                  } else {
                    setState(() => _isLoading = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Failed to submit proposal."), backgroundColor: Colors.red)
                    );
                  }
                },
                child: const Text("SUBMIT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: Text("Hello, ${widget.user['fullname'].split(' ')[0]}", style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white, foregroundColor: const Color(0xFF1A237E), elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout), 
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()))
          )
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: Color(0xFF1A237E))) 
        : _proposals.isEmpty 
          // Added a nice message if the student has no proposals yet
          ? const Center(child: Text("No proposals yet. Tap + to create one!", style: TextStyle(color: Colors.grey)))
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _proposals.length,
              itemBuilder: (context, index) {
                final p = _proposals[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(20),
                    title: Text(p['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    subtitle: Text(p['description'], maxLines: 2, overflow: TextOverflow.ellipsis),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: _getStatusColor(p['status']).withOpacity(0.1), borderRadius: BorderRadius.circular(15)),
                      child: Text(p['status'].toUpperCase(), style: TextStyle(color: _getStatusColor(p['status']), fontWeight: FontWeight.bold, fontSize: 11)),
                    ),
                    onTap: () => _viewFeedback(p['id']),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        // NEW: Calling the method we created above
        onPressed: _showAddProposalDialog,
        backgroundColor: const Color(0xFF1A237E),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("New Proposal", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}