const globalService = require('../services/global.service');
const logger = require('../config/logger');
const { successResponse, errorResponse } = require('../utils/response');

class AuthController {
  async login(req, res) {
    try {
      const { correo, password } = req.body;
      if (!correo || !password) {
        return errorResponse(res, 'Correo y contraseña son obligatorios');
      }
      const userSession = await globalService.login(correo, password);
      if (!userSession) {
        return errorResponse(res, 'Credenciales incorrectas');
      }
      return successResponse(res, userSession);
    } catch (error) {
      logger.error('Error en Login:', error);
      return errorResponse(res, error.message);
    }
  }
}

module.exports = new AuthController();
