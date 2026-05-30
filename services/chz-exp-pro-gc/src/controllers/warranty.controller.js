const axios = require('axios');
const logger = require('../config/logger');
const { successResponse, errorResponse } = require('../utils/response');

const PROCESS_API_URL = process.env.PROCESS_API_URL;

class WarrantyController {
  async getCatalogs(req, res) {
    try {
      const response = await axios.get(`${PROCESS_API_URL}/api/catalogos`);
      return successResponse(res, response.data);
    } catch (error) {
      logger.error('Error al obtener catálogos en capa Experience:', error.message);
      return errorResponse(res, 'Error al obtener catálogos: ' + error.message);
    }
  }

  async create(req, res) {
    try {
      const { categoria, lugar_compra, descripcion, direccion } = req.body;
      if (!categoria || !lugar_compra || !descripcion || !direccion) {
        return errorResponse(res, 'Campos obligatorios faltantes: categoria, lugar_compra, descripcion o direccion');
      }

      const cliente = req.user.cliente; // From JWT
      const response = await axios.post(`${PROCESS_API_URL}/api/garantias`, {
        ...req.body,
        cliente
      });
      return successResponse(res, response.data);
    } catch (error) {
      logger.error('Error al crear garantía en capa Experience:', error.message);
      return errorResponse(res, 'Error al registrar garantía: ' + error.message);
    }
  }


  async get(req, res) {
    try {
      const cliente = req.user.cliente; // From JWT
      const tipo = req.query.tipo || 'historial';
      const response = await axios.get(`${PROCESS_API_URL}/api/garantias`, {
        params: { cliente, tipo }
      });
      return successResponse(res, response.data);
    } catch (error) {
      logger.error('Error al obtener garantías en capa Experience:', error.message);
      return errorResponse(res, 'Error al consultar garantías: ' + error.message);
    }
  }
}

module.exports = new WarrantyController();

