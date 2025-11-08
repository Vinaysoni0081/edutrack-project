const mysql = require('mysql2');
const db = mysql.createConnection({
  host: '127.0.0.1', 
  user: 'root',
  password: 'vinaysoni0081',     
  database: 'edutrack',
  port: 3306          
});
db.connect((err) => {
  if (err) throw err;
  console.log('MySQL connected');
});

module.exports = db;
