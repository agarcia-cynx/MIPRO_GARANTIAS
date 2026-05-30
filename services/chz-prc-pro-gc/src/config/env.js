const fs = require('fs');
const path = require('path');
const yaml = require('js-yaml');
const logger = require('./logger');

/**
 * Loads environment variables from YAML files for local development.
 * In Cloud Run, variables are injected directly into process.env.
 */
const loadEnv = () => {
  const nodeEnv = process.env.NODE_ENV || 'development';
  const envMap = {
    production: 'env.prod.yaml',
    qa: 'env.qa.yaml',
    development: 'env.dev.yaml'
  };
  const fileName = envMap[nodeEnv] || 'env.dev.yaml';
  const filePath = path.join(process.cwd(), fileName);

  try {
    if (fs.existsSync(filePath)) {
      const config = yaml.load(fs.readFileSync(filePath, 'utf8'));
      
      Object.entries(config).forEach(([key, value]) => {
        if (!process.env[key]) {
          process.env[key] = value;
        }
      });
      
      logger.info(`Variables de entorno cargadas desde ${fileName}`);
    } else {
      logger.warn(`${fileName} no encontrado. Usando variables de entorno existentes.`);
    }
  } catch (error) {
    logger.error(`Error al cargar ${fileName}:`, error);
  }
};

module.exports = loadEnv;
