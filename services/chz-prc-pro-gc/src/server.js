const loadEnv = require('./config/env');
loadEnv();

const app = require('./app');
const logger = require('./config/logger');

const PORT = process.env.PORT;

const startServer = async () => {
  const server = app.listen(PORT, () => {
    logger.info(`Servidor ejecutándose en el puerto ${PORT}`);
  });

  /**
   * Graceful Shutdown for Google Cloud Run
   */
  process.on('SIGTERM', () => {
    logger.info('Señal SIGTERM recibida: cerrando servidor HTTP');
    server.close(() => {
      logger.info('Servidor HTTP cerrado');
      process.exit(0);
    });
  });

  process.on('SIGINT', () => {
    logger.info('Señal SIGINT recibida: cerrando servidor HTTP');
    server.close(() => {
      logger.info('Servidor HTTP cerrado');
      process.exit(0);
    });
  });
};

startServer().catch(err => {
  logger.error('Error al iniciar el servidor:', err);
  process.exit(1);
});

