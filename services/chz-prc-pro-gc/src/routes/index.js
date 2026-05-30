const express = require('express');
const router = express.Router();
const authController = require('../controllers/auth.controller');
const globalController = require('../controllers/global.controller');
const warrantyController = require('../controllers/warranty.controller');
const mediaController = require('../controllers/media.controller');
const customerController = require('../controllers/customer.controller');
const multer = require('multer');

// Setup multer memory storage for file uploads
const upload = multer({
  storage: multer.memoryStorage()
});

/**
 * API Routes definitions
 */
router.post('/login', authController.login);
router.get('/catalogos', globalController.getCatalogs);
router.post('/garantias', warrantyController.create);
router.get('/garantias', warrantyController.get);
router.post('/media', upload.single('file'), mediaController.upload);
router.post('/direcciones', customerController.createAddress);

module.exports = router;

