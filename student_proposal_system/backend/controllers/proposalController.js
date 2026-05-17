const db = require('../config/db');

exports.createProposal = async (req, res) => {
    try {
        const { user_id, title, description } = req.body;
        
        const [result] = await db.execute(
            'INSERT INTO proposals (user_id, title, description, status) VALUES (?, ?, ?, ?)',
            [user_id, title, description, 'pending']
        );

        res.status(201).json({ 
            message: "Proposal submitted successfully!", 
            proposalId: result.insertId 
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// Get proposals for a specific student
exports.getStudentProposals = async (req, res) => {
    try {
        const { userId } = req.params;
        const [proposals] = await db.execute(
            'SELECT * FROM proposals WHERE user_id = ? ORDER BY created_at DESC', 
            [userId]
        );
        res.json(proposals);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// ==========================================
// THE FIX IS HERE (Get ALL proposals)
// ==========================================
exports.getAllProposals = async (req, res) => {
    try {
        // FIXED: We removed "as student_name" so the backend sends exactly what Flutter wants: 'fullname'
        const [proposals] = await db.execute(`
            SELECT proposals.*, users.fullname 
            FROM proposals 
            JOIN users ON proposals.user_id = users.id 
            ORDER BY created_at DESC
        `);
        res.json(proposals);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// Update Proposal Status (Approve/Reject)
exports.updateStatus = async (req, res) => {
    try {
        const { id } = req.params;
        const { status, teacher_id } = req.body; // status should be 'approved' or 'rejected'

        await db.execute(
            'UPDATE proposals SET status = ? WHERE id = ?',
            [status, id]
        );

        // Optional: Log the status change in status_logs
        await db.execute(
            'INSERT INTO status_logs (proposal_id, status, updated_by) VALUES (?, ?, ?)',
            [id, status, teacher_id]
        );

        res.json({ message: `Proposal ${status} successfully!` });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};