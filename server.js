const express = require('express');
const swaggerJsdoc = require('swagger-jsdoc');
const swaggerUi = require('swagger-ui-express');
const authRoutes = require('./routes/auth');
const studentRoutes = require('./routes/students');
const app = express();

app.use(express.json());
app.use('/api/auth', authRoutes);
app.use('/api/students', studentRoutes);

const swaggerOptions = {
  definition: {
    openapi: '3.0.0',
    info: { title: 'EduTrack API', version: '1.0.0' },
  },
  apis: ['./routes/*.js'],
};
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerJsdoc(swaggerOptions)));

app.listen(3000, () => console.log('EduTrack running on port 3000'));