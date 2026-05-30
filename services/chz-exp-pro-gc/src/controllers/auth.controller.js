const axios = require('axios');
const jwt = require('jsonwebtoken');
const logger = require('../config/logger');
const { successResponse, errorResponse } = require('../utils/response');

const PROCESS_API_URL = process.env.PROCESS_API_URL;

class AuthController {
  async login(req, res) {
    try {
      const { correo, password } = req.body;
      if (!correo || !password) {
        return errorResponse(res, 'Correo y contraseña son obligatorios');
      }

      // Delegate to Process API to check user credentials
      const response = await axios.post(`${PROCESS_API_URL}/api/login`, { correo, password });
      
      const data = response.data;
      if (data.resultado && data.resultado.codigo !== 0) {
        return res.status(200).json(data);
      }

       // If credentials check passed, generate JWT token
       const user = data;
       const secret = process.env.JWT_SECRET;
       if (!secret) {
         throw new Error('La variable de entorno JWT_SECRET es obligatoria.');
       }
       // Usamos user.id para ambos campos en el JWT, ya que representan lo mismo
       const token = jwt.sign(
         { id: user.id, nombre: user.nombre, cliente: user.id },
         secret,
         { expiresIn: '24h' }
       );

       return successResponse(res, {
         token,
         user: {
           id: user.id,
           nombre: user.nombre
         },
         last_updated_catalogues: user.last_updated_catalogues
       });

    } catch (error) {
      logger.error('Error de login en capa Experience:', error.message);
      return errorResponse(res, 'Error al autenticar usuario: ' + (error.response?.data?.resultado?.mensaje || error.message));
    }
  }
}

module.exports = new AuthController();
