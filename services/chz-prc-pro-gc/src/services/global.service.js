const axios = require('axios');
const logger = require('../config/logger');

class GlobalService {
  async login(correo, password) {
    const DATABASE_API_URL = process.env.DATABASE_API_URL;
    const fullUrl = `${DATABASE_API_URL}/api/login`;
    logger.info(`[DB API] Iniciando login para ${correo} a la URL: ${fullUrl}`);
    const response = await axios.post(fullUrl, { correo, password });
    
    const result = response.data;
    if (!result || result.resultado?.codigo !== 0) {
      throw new Error(result?.resultado?.mensaje || 'Error en autenticación con la API de BD');
    }
    
    return {
      id: result.id,
      nombre: result.nombre,
      last_updated_catalogues: result.last_updated_catalogues
    };
  }

  async getCatalogs() {
    const DATABASE_API_URL = process.env.DATABASE_API_URL;
    logger.info('[DB API] Consultando catálogos');
    const response = await axios.get(`${DATABASE_API_URL}/api/catalogos`);
    
    const result = response.data;
    if (!result || result.resultado?.codigo !== 0) {
      throw new Error(result?.resultado?.mensaje || 'Error al obtener catálogos de la API de BD');
    }
    
    return {
      last_updated: result.last_updated,
      productos: result.productos,
      marcas: result.marcas,
      lugares_compra: result.lugares_compra
    };
  }

  async createAddress(data) {
    const { cliente, direccion } = data;
    if (!cliente || !direccion) {
      throw new Error('Campos obligatorios faltantes: cliente, direccion');
    }

    const DATABASE_API_URL = process.env.DATABASE_API_URL;
    logger.info('[DB API] Registrando dirección');
    const response = await axios.post(`${DATABASE_API_URL}/api/direcciones`, data);
    
    const result = response.data;
    if (!result || result.resultado?.codigo !== 0) {
      throw new Error(result?.resultado?.mensaje || 'Error al registrar dirección en la API de BD');
    }
    
    return result.direccionId;
  }
}

module.exports = new GlobalService();
