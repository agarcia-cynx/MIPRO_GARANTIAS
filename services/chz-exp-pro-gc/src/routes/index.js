const express = require('express');
const router = express.Router();
const authController = require('../controllers/auth.controller');
const warrantyController = require('../controllers/warranty.controller');
const mediaController = require('../controllers/media.controller');
const customerController = require('../controllers/customer.controller');
const authMiddleware = require('../middlewares/auth.middleware');
const multer = require('multer');

// Setup multer memory storage for file uploads
const upload = multer({
  storage: multer.memoryStorage()
});

/**
 * API Routes definitions
 */
// Public routes
router.post('/login', authController.login);

// Protected routes (require JWT)
router.get('/catalogos', authMiddleware, warrantyController.getCatalogs);
router.post('/garantias', authMiddleware, warrantyController.create);
router.get('/garantias', authMiddleware, warrantyController.get);
router.post('/media', authMiddleware, upload.single('file'), mediaController.upload);
router.post('/direcciones', authMiddleware, customerController.createAddress);

module.exports = router;

