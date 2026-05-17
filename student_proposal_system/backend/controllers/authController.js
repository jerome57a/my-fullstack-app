const db = require('../config/db');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

exports.register = async (req, res) => {
    try {
        const { fullname, email, password, role } = req.body;

        // 1. Hash the password for security
        const hashedPassword = await bcrypt.hash(password, 10);

        // 2. Insert into MySQL
        const [result] = await db.execute(
            'INSERT INTO users (fullname, email, password, role) VALUES (?, ?, ?, ?)',
            [fullname, email, hashedPassword, role]
        );

        res.status(201).json({ message: "User registered successfully!" });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

exports.login = async (req, res) => {
    try {
        const { email, password } = req.body;
        
        // DEBUG LOGS - Check your terminal after tapping login!
        console.log("--- Login Attempt ---");
        console.log("Email from Flutter:", `"${email}"`); // Quotes show hidden spaces
        console.log("Password from Flutter:", `"${password}"`);

        const [users] = await db.execute('SELECT * FROM users WHERE email = ?', [email]);
        
        if (users.length === 0) {
            console.log("Result: User email not found in database.");
            return res.status(404).json({ message: "User not found" });
        }

        const user = users[0];
        console.log("User found in DB:", user.fullname);

        const isMatch = await bcrypt.compare(password, user.password);
        console.log("Bcrypt Match Result:", isMatch);

        if (!isMatch) {
            return res.status(401).json({ message: "Invalid credentials" });
        }

        const token = jwt.sign(
            { id: user.id, role: user.role }, 
            process.env.JWT_SECRET, 
            { expiresIn: '1d' }
        );

        res.json({ 
            token, 
            user: { id: user.id, fullname: user.fullname, role: user.role } 
        });
    } catch (error) {
        console.error("Login Error:", error.message);
        res.status(500).json({ error: error.message });
    }
};