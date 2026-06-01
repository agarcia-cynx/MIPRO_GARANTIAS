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
router.post('/x1-a7f', authController.login);

// Protected routes (require JWT)
router.get('/x2-b9k', authMiddleware, warrantyController.getCatalogs);
router.post('/x3-m4q', authMiddleware, warrantyController.create);
router.get('/x3-m4q', authMiddleware, warrantyController.get);
router.post('/x4-h8w', authMiddleware, upload.single('file'), mediaController.upload);
router.post('/x5-p2y', authMiddleware, customerController.createAddress);

module.exports = router;

