# Student Proposal System

A full-stack application that allows students to submit project proposals and teachers to review and provide feedback.

## Tech Stack
* **Frontend:** Flutter
* **Backend:** Node.js (Express.js)
* **Database:** MySQL

## Project Structure
* `student_proposal_flutter/` - Flutter mobile application containing student and teacher dashboards.
* `student_proposal_system/backend/` - Node.js REST API handling authentication, proposals, and feedback.
* `student_proposal_system.sql` - MySQL database schema.

## Setup Instructions

### 1. Database Configuration
1. Open XAMPP and start Apache and MySQL.
2. Go to `http://localhost/phpmyadmin`.
3. Create a new database named `student_proposal_system`.
4. Import the `student_proposal_system.sql` file into the database.

### 2. Backend Setup
1. Open a terminal and navigate to the backend folder:
   ```bash
   cd student_proposal_system/backend
