const express = require('express');
const router = express.Router();

// importing controller 
const {createTodo} = require('../controllers/createTodo');
const {getTodos, getTodoById} = require('../controllers/getTodos');
const { updateTodo } = require('../controllers/updateTodo');
const { deleteTodo } = require('../controllers/deleteTodo');

// define api route 
router.post('/createTodo', createTodo);

//Fetching Todos
router.get('/getTodos', getTodos);
router.get('/getTodos/:id', getTodoById);

//Update Todo
router.put('/updateTodo/:id', updateTodo);

//Delete Todo
router.delete('/deleteTodo/:id', deleteTodo);


module.exports = router;