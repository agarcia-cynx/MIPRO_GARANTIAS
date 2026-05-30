const globalService = require('../services/global.service');
const logger = require('../config/logger');
const { successResponse, errorResponse } = require('../utils/response');

class CustomerController {
  async createAddress(req, res) {
    try {
      const direccionId = await globalService.createAddress(req.body);
      return successResponse(res, { direccion: direccionId });
    } catch (error) {
      logger.error('Error al crear dirección:', error);
      return errorResponse(res, error.message);
    }
  }
}

module.exports = new CustomerController();
