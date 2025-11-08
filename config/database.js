const mysql = require('mysql2');
const db = mysql.createConnection({
  host: '127.0.0.1',  // use IPv4 loopback
  user: 'root',
  password: 'vinaysoni0081',       // update if your MySQL root user has a password
  database: 'edutrack',
  port: 3306          // explicitly specify port
});
db.connect((err) => {
  if (err) throw err;
  console.log('MySQL connected');
});
module.exports = db;