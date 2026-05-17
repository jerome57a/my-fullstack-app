const express = require('express');
const cors = require('cors');
require('dotenv').config();
const db = require('./config/db.js');

// 1. IMPORT ALL ROUTES
const authRoutes = require('./routes/authRoutes');
const proposalRoutes = require('./routes/proposalRoutes');
const feedbackRoutes = require('./routes/feedbackRoutes');

// 2. CREATE THE APP
const app = express();

// 3. MIDDLEWARE (Crucial: Must come before routes)
app.use(cors());
app.use(express.json()); // This allows the server to read your Postman Body

// 4. ATTACH THE ROUTES
app.use('/api/auth', authRoutes);
app.use('/api/proposals', proposalRoutes);
app.use('/api/feedback', feedbackRoutes);

// Base route
app.get('/', (req, res) => {
    res.send('Student Proposal API is running...');
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`🚀 Server running on http://localhost:${PORT}`);
});