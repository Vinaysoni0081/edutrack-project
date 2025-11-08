const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const db = require('../config/database');
const router = express.Router();

router.post('/register', async (req, res) => {
  const { name, email, password, role } = req.body;
  const hashedPassword = await bcrypt.hash(password, 10);
  db.query('INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)', [name, email, hashedPassword, role], (err) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json({ message: 'User registered' });
  });
});

router.post('/login', (req, res) => {
  const { email, password } = req.body;
  db.query('SELECT * FROM users WHERE email = ?', [email], async (err, results) => {
    if (err || results.length === 0) return res.status(400).json({ error: 'Invalid credentials' });
    const user = results[0];
    const validPass = await bcrypt.compare(password, user.password);
    if (!validPass) return res.status(400).json({ error: 'Invalid credentials' });
    const token = jwt.sign({ id: user.id, role: user.role }, 'secretkey');
    res.json({ token });
  });
});

module.exports = router;