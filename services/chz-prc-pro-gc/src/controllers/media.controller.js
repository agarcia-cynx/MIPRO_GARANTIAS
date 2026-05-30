const storageService = require('../services/storage.service');
const logger = require('../config/logger');
const { successResponse, errorResponse } = require('../utils/response');

class MediaController {
  async upload(req, res) {
    try {
      const { garantia } = req.body;
      if (!garantia) {
        return errorResponse(res, 'El ID de garantía es obligatorio');
      }

      if (!req.file) {
        return errorResponse(res, 'No se recibió ningún archivo adjunto');
      }

      const folder = `${process.env.SYSTEM_STORAGE_FOLDER_PREFIX}/${garantia}`;
      
      const fileUrl = await storageService.uploadFile(req.file, folder);
      
      logger.info(`Archivo subido exitosamente a GCP. URL: ${fileUrl}`);

      const mediaData = {
        garantia,
        tipo: req.file.mimetype,
        url: fileUrl
      };

      const mediaResult = await storageService.saveMediaUrl(mediaData);

      return successResponse(res, {
        media: mediaResult.mediaId,
        url: mediaResult.url
      });
    } catch (error) {
      logger.error('Error al crear media:', error);
      return errorResponse(res, error.message);
    }
  }
}

module.exports = new MediaController();
