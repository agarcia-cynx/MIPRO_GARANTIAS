const warrantyService = require('../services/warranty.service');
const logger = require('../config/logger');
const { successResponse, errorResponse } = require('../utils/response');

class WarrantyController {
  async create(req, res) {
    try {
      const dbResult = await warrantyService.createWarranty(req.body);
      return successResponse(res, { garantia: dbResult });
    } catch (error) {
      logger.error('Error al crear garantía:', error);
      return errorResponse(res, error.message);
    }
  }

  async get(req, res) {
    try {
      const { cliente, tipo } = req.query;
      const garantias = await warrantyService.getWarranties(cliente, tipo);
      return successResponse(res, { garantias });
    } catch (error) {
      logger.error('Error al obtener garantías:', error);
      return errorResponse(res, error.message);
    }
  }
}

module.exports = new WarrantyController();
