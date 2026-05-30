const logger = require('../config/logger');

/**
 * Global Error Handler Middleware.
 * Captures all errors and returns a structured JSON response.
 */
const errorHandler = (err, req, res, next) => {
  const errorCode = err.codigo || 1; // Default error code > 0
  const message = err.message || 'Internal Server Error';

  logger.error({
    message: err.message,
    stack: err.stack,
    path: req.path,
    method: req.method,
  });

  // Always return HTTP 200 as per user requirement
  res.status(200).json({
    resultado: {
      codigo: errorCode,
      mensaje: message,
      warning: ''
    }
  });
};

module.exports = errorHandler;
