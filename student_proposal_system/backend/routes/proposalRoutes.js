const express = require('express');
const router = express.Router();
const proposalController = require('../controllers/proposalController');
const verifyToken = require('../middleware/authMiddleware'); // Import guard

// Add verifyToken to the routes you want to protect
router.post('/submit', verifyToken, proposalController.createProposal);
router.get('/user/:userId', verifyToken, proposalController.getStudentProposals);
router.get('/all', verifyToken, proposalController.getAllProposals);
router.put('/status/:id', verifyToken, proposalController.updateStatus);

module.exports = router;