CREATE DATABASE edutrack;
USE edutrack;

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  role ENUM('student', 'faculty', 'admin') NOT NULL,
  department VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE courses (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  code VARCHAR(50) UNIQUE NOT NULL,
  department VARCHAR(255),
  faculty_id INT,
  FOREIGN KEY (faculty_id) REFERENCES users(id)
);

CREATE TABLE enrollments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  student_id INT,
  course_id INT,
  enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (student_id) REFERENCES users(id),
  FOREIGN KEY (course_id) REFERENCES courses(id)
);

CREATE TABLE grades (
  id INT AUTO_INCREMENT PRIMARY KEY,
  enrollment_id INT,
  grade VARCHAR(10),
  entered_by INT,
  entered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (enrollment_id) REFERENCES enrollments(id),
  FOREIGN KEY (entered_by) REFERENCES users(id)
);

CREATE TABLE attendance (
  id INT AUTO_INCREMENT PRIMARY KEY,
  enrollment_id INT,
  date DATE,
  status ENUM('present', 'absent'),
  FOREIGN KEY (enrollment_id) REFERENCES enrollments(id)
);

-- Sample data
INSERT INTO users (name, email, password, role) VALUES ('Admin', 'admin@edu.com', '$2a$10$hashedpassword', 'admin');