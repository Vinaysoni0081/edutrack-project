const express = require('express');
const db = require('../config/database');
const { authenticate, authorize } = require('../middleware/auth');
const nodemailer = require('nodemailer');
const router = express.Router();

router.post('/enroll', authenticate, authorize(['student']), (req, res) => {
  const { course_id } = req.body;
  db.query('INSERT INTO enrollments (student_id, course_id) VALUES (?, ?)', [req.user.id, course_id], (err) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json({ message: 'Enrolled' });
  });
});

router.post('/grade', authenticate, authorize(['faculty']), (req, res) => {
  const { enrollment_id, grade } = req.body;
  db.query('INSERT INTO grades (enrollment_id, grade, entered_by) VALUES (?, ?, ?)', [enrollment_id, grade, req.user.id], (err) => {
    if (err) return res.status(500).json({ error: err.message });
    // Bonus: Email notification
    const transporter = nodemailer.createTransport({ service: 'gmail', auth: { user: 'your@email.com', pass: 'password' } });
//                                
    transporter.sendMail({ from: 'your@email.com', to: 'student@email.com', subject: 'Grade Update', text: `Your grade: ${grade}` });
    res.json({ message: 'Grade entered' });
  });
});

module.exports = router;