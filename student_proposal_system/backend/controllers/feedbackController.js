const db = require('../config/db');

exports.addFeedback = async (req, res) => {
    try {
        const { proposal_id, teacher_id, comment } = req.body;

        await db.execute(
            'INSERT INTO feedback (proposal_id, teacher_id, comment) VALUES (?, ?, ?)',
            [proposal_id, teacher_id, comment]
        );

        res.status(201).json({ message: "Feedback submitted!" });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

exports.getFeedbackByProposal = async (req, res) => {
    try {
        const { proposalId } = req.params;
        const [feedback] = await db.execute(
            'SELECT feedback.*, users.fullname as teacher_name FROM feedback JOIN users ON feedback.teacher_id = users.id WHERE proposal_id = ?',
            [proposalId]
        );
        res.json(feedback);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};