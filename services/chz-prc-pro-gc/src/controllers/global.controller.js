const globalService = require('../services/global.service');
const logger = require('../config/logger');
const { successResponse, errorResponse } = require('../utils/response');

class GlobalController {
  async getCatalogs(req, res) {
    try {
      const catalogos = await globalService.getCatalogs();
      return successResponse(res, catalogos);
    } catch (error) {
      logger.error('Error al obtener catálogos:', error);
      return errorResponse(res, error.message);
    }
  }
}

module.exports = new GlobalController();
