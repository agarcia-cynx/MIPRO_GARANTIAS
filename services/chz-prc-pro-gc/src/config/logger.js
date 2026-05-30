const winston = require('winston');

/**
 * Logger configuration for structured JSON logs in Google Cloud Logging.
 */
const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: winston.format.json(),
  defaultMeta: { service: 'chz-prc-pro-gc' },
  transports: [
    new winston.transports.Console(),
  ],
});

module.exports = logger;
