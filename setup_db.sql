SET FOREIGN_KEY_CHECKS = 0;

-- Drop tables if they exist to ensure a clean setup
DROP TABLE IF EXISTS Attendance;
DROP TABLE IF EXISTS Grades;
DROP TABLE IF EXISTS Enrollments;
DROP TABLE IF EXISTS Courses;
DROP TABLE IF EXISTS StudentProfiles;
DROP TABLE IF EXISTS Users;

-- 1. Users Table
-- Stores all users (Student, Faculty, Admin).
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    role ENUM('student', 'faculty', 'admin') NOT NULL, -- Role-based access control
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Courses Table
-- Stores details about the courses offered.
CREATE TABLE Courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_code VARCHAR(10) UNIQUE NOT NULL,
    course_name VARCHAR(255) NOT NULL,
    description TEXT,
    credits DECIMAL(2, 1) NOT NULL,
    faculty_id INT,
    FOREIGN KEY (faculty_id) REFERENCES Users(user_id) ON DELETE SET NULL -- Links to the primary instructor
);

-- 3. Enrollments Table
-- Tracks which students are registered for which courses (Many-to-Many).
CREATE TABLE Enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE NOT NULL,
    status ENUM('active', 'completed', 'dropped') DEFAULT 'active',
    -- Ensures a student can only be enrolled in a course once
    UNIQUE KEY unique_enrollment (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE
);

-- 4. Grades Table
-- Stores individual grades for a specific enrollment.
CREATE TABLE Grades (
    grade_id INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_id INT NOT NULL,
    faculty_id INT NOT NULL,
    grade_type VARCHAR(50) NOT NULL, -- e.g., 'Midterm', 'Final Exam'
    score DECIMAL(5, 2) NOT NULL,
    max_score DECIMAL(5, 2) DEFAULT 100.00,
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (enrollment_id) REFERENCES Enrollments(enrollment_id) ON DELETE CASCADE,
    FOREIGN KEY (faculty_id) REFERENCES Users(user_id) ON DELETE RESTRICT
);

-- 5. Attendance Table
-- Tracks attendance records with date/time stamps.
CREATE TABLE Attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_id INT NOT NULL,
    attendance_date DATE NOT NULL,
    status ENUM('present', 'absent', 'late') NOT NULL,
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (enrollment_id) REFERENCES Enrollments(enrollment_id) ON DELETE CASCADE,
    UNIQUE KEY unique_attendance (enrollment_id, attendance_date)
);

-- 6. StudentProfiles Table (Additional user detail table)
-- Stores additional student-specific information.
CREATE TABLE StudentProfiles (
    profile_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT UNIQUE NOT NULL,
    date_of_birth DATE,
    major VARCHAR(100),
    admission_year YEAR,
    phone_number VARCHAR(20),
    FOREIGN KEY (student_id) REFERENCES Users(user_id) ON DELETE CASCADE
);


-- --- Sample Data Insertion ---

-- NOTE: The password_hash values here are dummy placeholders. 
-- The server.js code is temporarily hardcoded to accept 'adminpass', 'facpass', and 'studpass' 
-- until we implement the proper registration route with bcrypt hashing.

-- Insert Admin (Password: adminpass)
INSERT INTO Users (username, password_hash, first_name, last_name, email, role) VALUES
('admin01', 'dummy_admin_hash', 'System', 'Admin', 'admin@univ.edu', 'admin');

-- Insert Faculty (Password: facpass)
INSERT INTO Users (username, password_hash, first_name, last_name, email, role) VALUES
('profsmith', 'dummy_faculty_hash', 'Jane', 'Smith', 'jane.smith@univ.edu', 'faculty');

-- Insert Students (Password: studpass)
INSERT INTO Users (username, password_hash, first_name, last_name, email, role) VALUES
('johnnydoe', 'dummy_student_hash', 'Johnny', 'Doe', 'johnny.doe@univ.edu', 'student'),
('alicejones', 'dummy_student_hash', 'Alice', 'Jones', 'alice.jones@univ.edu', 'student');

-- Insert Student Profiles
INSERT INTO StudentProfiles (student_id, date_of_birth, major, admission_year) VALUES
(3, '2004-05-15', 'Computer Science', 2022),
(4, '2003-11-21', 'Applied Mathematics', 2021);

-- Insert Courses (Taught by Jane Smith, user_id=2)
INSERT INTO Courses (course_code, course_name, description, credits, faculty_id) VALUES
('CS101', 'Introduction to Programming', 'Fundamentals of coding and logic.', 3.0, 2),
('MA205', 'Discrete Mathematics', 'Logic, set theory, and proofs.', 4.0, 2);

-- Enroll Students (Johnny Doe=3, Alice Jones=4)
INSERT INTO Enrollments (student_id, course_id, enrollment_date) VALUES
(3, 1, '2023-09-01'), -- Johnny in CS101 (Enrollment ID 1)
(3, 2, '2023-09-01'), -- Johnny in MA205 (Enrollment ID 2)
(4, 1, '2023-09-01'); -- Alice in CS101 (Enrollment ID 3)

-- Record Grades for Johnny in CS101 (Enrollment ID 1)
INSERT INTO Grades (enrollment_id, faculty_id, grade_type, score) VALUES
(1, 2, 'Midterm', 85.5),
(1, 2, 'Project', 92.0);

-- Record Attendance for Alice in CS101 (Enrollment ID 3)
INSERT INTO Attendance (enrollment_id, attendance_date, status) VALUES
(3, '2023-10-01', 'present'),
(3, '2023-10-02', 'absent');

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;
