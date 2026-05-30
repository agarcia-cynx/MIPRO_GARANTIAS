const express = require('express');
const helmet = require('helmet');
const cors = require('cors');
const routes = require('./routes');
const errorHandler = require('./middlewares/error.middleware');

const app = express();

app.use(helmet({
}));
app.use(cors());

app.use(express.json());

app.use('/api', routes);

app.use(errorHandler);

module.exports = app;

