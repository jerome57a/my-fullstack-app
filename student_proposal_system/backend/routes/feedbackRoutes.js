const express = require('express');
const router = express.Router();
const feedbackController = require('../controllers/feedbackController');

router.post('/add', feedbackController.addFeedback);
router.get('/:proposalId', feedbackController.getFeedbackByProposal);

module.exports = router;