const axios = require('axios');
const logger = require('../config/logger');
const globalService = require('./global.service');
const storageService = require('./storage.service');

class WarrantyService {
 
  async createWarranty(data) {
    // Validar campos obligatorios
    const { categoria, lugar_compra, descripcion, direccion, cliente, estado } = data;
    
    if (!categoria || !lugar_compra || !descripcion || !direccion || !cliente || !estado) {
      throw new Error('Campos obligatorios faltantes: categoria, lugar_compra, descripcion, direccion, cliente, estado');
    }

    // Validar longitud de códigos de catálogos (deben ser de 1 carácter)
    if (categoria.length !== 1) throw new Error('Código de categoría debe ser de 1 carácter');
    if (lugar_compra.length !== 1) throw new Error('Código de lugar de compra debe ser de 1 carácter');
    if (data.marca && data.marca.length !== 1) throw new Error('Código de marca debe ser de 1 carácter');
    if (estado.length !== 1) throw new Error('Código de estado debe ser de 1 carácter');

    const DATABASE_API_URL = process.env.DATABASE_API_URL;
    logger.info('[DB API] Registrando garantía');
    const response = await axios.post(`${DATABASE_API_URL}/api/garantias`, data);
    
    const result = response.data;
    if (!result || result.resultado?.codigo !== 0) {
      throw new Error(result?.resultado?.mensaje || 'Error al registrar garantía en la API de BD');
    }
    
    return result.garantiaId;
  }

  async getWarranties(cliente, tipo) {
    if (!cliente) {
      throw new Error('Identificador de cliente es obligatorio');
    }

    const DATABASE_API_URL = process.env.DATABASE_API_URL;
    logger.info(`[DB API] Consultando garantías para cliente ${cliente}`);
    const response = await axios.get(`${DATABASE_API_URL}/api/garantias`, {
      params: { cliente, tipo }
    });
    
    const result = response.data;
    if (!result || result.resultado?.codigo !== 0) {
      throw new Error(result?.resultado?.mensaje || 'Error al obtener garantías de la API de BD');
    }
    
    return result.garantias;
  }
}

module.exports = new WarrantyService();
