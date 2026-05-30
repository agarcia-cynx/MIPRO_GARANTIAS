const axios = require('axios');
const FormData = require('form-data');
const logger = require('../config/logger');

class StorageService {
  /**
   * Sube un archivo a la API de Storage externa (GCP).
   * @param {Object} file - Archivo proveniente de multer
   * @param {string} folder - Carpeta destino
   * @returns {Promise<string>} URL pública del archivo de forma garantizada
   */
  async uploadFile(file, folder) {
    const SYSTEM_STORAGE_API_URL = process.env.SYSTEM_STORAGE_API_URL;

    const form = new FormData();
    form.append('file', file.buffer, {
      filename: file.originalname,
      contentType: file.mimetype,
    });

    logger.info(`Subiendo archivo a Storage API en carpeta ${folder}`);
    const storageResponse = await axios.post(
      SYSTEM_STORAGE_API_URL,
      form,
      {
        params: { carpeta: folder },
        headers: { ...form.getHeaders() }
      }
    );

    const storageResult = storageResponse.data;

    if (storageResult.resultado?.codigo !== 0) {
      logger.error('Error de Storage API: ' + JSON.stringify(storageResult));
      throw new Error(storageResult?.resultado?.mensaje || 'La API de almacenamiento en google cloud storage falló');
    }

    return storageResult.url;
  }

  async saveMediaUrl(data) {
    const { garantia, tipo, url } = data;
    if (!garantia || !tipo || !url) {
      throw new Error('Campos obligatorios faltantes: garantia, tipo, url');
    }

    const DATABASE_API_URL = process.env.DATABASE_API_URL;
    logger.info('[DB API] Registrando URL multimedia');
    const response = await axios.post(`${DATABASE_API_URL}/api/media`, data);
    
    const result = response.data;
    if (!result || result.resultado?.codigo !== 0) {
      throw new Error(result?.resultado?.mensaje || 'Error al registrar multimedia en la API de BD');
    }
    
    return {
      mediaId: result.mediaId,
      url: data.url
    };
  }
}

module.exports = new StorageService();
