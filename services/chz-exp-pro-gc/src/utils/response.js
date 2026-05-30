// Success response helper
const successResponse = (res, data = {}) => {
  const response = {
    resultado: {
      codigo: 0,
      mensaje: "",
      warning: ""
    }
  };

  // Solo añadimos propiedades si data contiene algo útil
  if (data && typeof data === 'object' && Object.keys(data).length > 0) {
    Object.assign(response, data);
  }

  return res.status(200).json(response);
};

// Error response helper
const errorResponse = (res, message, code = 1) => {
  return res.status(200).json({
    resultado: {
      codigo: code,
      mensaje: message,
      warning: ""
    }
  });
};

module.exports = { successResponse, errorResponse };
