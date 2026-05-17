```markdown
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

```

2. Install dependencies:
```bash
npm install

```


3. Configure your `.env` file with your database credentials and JWT secret.
4. Start the server:
```bash
node server.js

```



### 3. Frontend Setup

1. Open a new terminal and navigate to the frontend folder:
```bash
cd student_proposal_flutter

```


2. Install Flutter dependencies:
```bash
flutter pub get

```


3. Update the API base URL in `lib/services/api_service.dart` to match your local backend IP if testing on a physical device.
4. Run the application:
```bash
flutter run

```



## Author

Jerome S. Aguilar

```

```
