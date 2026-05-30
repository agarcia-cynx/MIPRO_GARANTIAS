const jwt = require('jsonwebtoken');

const authMiddleware = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  if (!authHeader) {
    return res.status(200).json({
      resultado: {
        codigo: 401,
        mensaje: 'No se proporcionó token de autorización',
        warning: ''
      }
    });
  }

  const parts = authHeader.split(' ');
  if (parts.length !== 2 || parts[0] !== 'Bearer') {
    return res.status(200).json({
      resultado: {
        codigo: 401,
        mensaje: 'Formato de token inválido (se esperaba Bearer <token>)',
        warning: ''
      }
    });
  }

  const token = parts[1];
  const secret = process.env.JWT_SECRET;

  if (!secret) {
    return res.status(200).json({
      resultado: {
        codigo: 500,
        mensaje: 'Error de configuración del servidor (JWT_SECRET faltante)',
        warning: ''
      }
    });
  }

  jwt.verify(token, secret, (err, decoded) => {
    if (err) {
      return res.status(200).json({
        resultado: {
          codigo: 401,
          mensaje: 'Token inválido o expirado',
          warning: ''
        }
      });
    }

    req.user = decoded;
    next();
  });
};

module.exports = authMiddleware;
