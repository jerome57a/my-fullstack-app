const jwt = require('jsonwebtoken');

const verifyToken = (req, res, next) => {
    // Get token from the header
    const token = req.headers['authorization'];

    if (!token) {
        return res.status(403).json({ message: "No token provided. Access denied." });
    }

    try {
        // Bearer <token>
        const bearerToken = token.split(' ')[1];
        const decoded = jwt.verify(bearerToken, process.env.JWT_SECRET);
        req.user = decoded; // Adds user id and role to the request
        next();
    } catch (err) {
        return res.status(401).json({ message: "Invalid or expired token." });
    }
};

module.exports = verifyToken;