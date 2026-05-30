const axios = require('axios');
const logger = require('../config/logger');
const { successResponse, errorResponse } = require('../utils/response');

const PROCESS_API_URL = process.env.PROCESS_API_URL;

class CustomerController {
  async createAddress(req, res) {
    try {
      const cliente = req.user.cliente; // From JWT
      const response = await axios.post(`${PROCESS_API_URL}/api/direcciones`, {
        ...req.body,
        cliente
      });
      return successResponse(res, response.data);
    } catch (error) {
      logger.error('Error al crear dirección en capa Experience:', error.message);
      return errorResponse(res, 'Error al registrar dirección: ' + error.message);
    }
  }
}

module.exports = new CustomerController();
