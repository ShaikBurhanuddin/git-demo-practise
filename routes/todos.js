const express = require('express');
const router = express.Router();

// importing controller 
const {createTodo} = require('../controllers/createTodo');

// define api route 
router.post('/createTodo', createTodo);

module.exports = router;