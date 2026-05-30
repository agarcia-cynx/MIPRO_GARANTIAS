const axios = require('axios');
const logger = require('../config/logger');
const { successResponse, errorResponse } = require('../utils/response');

const PROCESS_API_URL = process.env.PROCESS_API_URL;

class MediaController {
  async upload(req, res) {
    try {
      const { garantia } = req.body;
      if (!garantia) {
        return errorResponse(res, 'El ID de garantía es obligatorio');
      }

      if (!req.file) {
        return errorResponse(res, 'No se adjuntó ningún archivo');
      }

      // Pack the file and other fields into a FormData object to forward to Process API
      const FormData = require('form-data');
      const form = new FormData();
      form.append('file', req.file.buffer, {
        filename: req.file.originalname,
        contentType: req.file.mimetype,
      });
      form.append('garantia', garantia);

      logger.info(`Forwarding media upload request to Process API at ${PROCESS_API_URL}/api/media`);
      const response = await axios.post(
        `${PROCESS_API_URL}/api/media`,
        form,
        {
          headers: {
            ...form.getHeaders()
          }
        }
      );

      return successResponse(res, response.data);
    } catch (error) {
      logger.error('Error al crear media en capa Experience:', error.message);
      return errorResponse(res, 'Error al procesar archivo adjunto: ' + (error.response?.data?.resultado?.mensaje || error.message));
    }
  }
}

module.exports = new MediaController();
