const winston = require('winston');

/**
 * Logger configuration for structured JSON logs in Google Cloud Logging.
 */
const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: winston.format.json(),
  defaultMeta: { service: 'chz-exp-pro-gc' },
  transports: [
    new winston.transports.Console(),
  ],
});

module.exports = logger;
