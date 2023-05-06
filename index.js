const express = require('express');
const app = express();

//Load config from env file (good practice for port)
require('dotenv').config();

//Taking port from env or by default 8000
const PORT = process.env.PORT || 8000;

// Middleware to parse json req.body
app.use(express.json());

// Importing routed for TODO API
const todoRoutes = require('./routes/todos');

//Mounting the todo API Routes
app.use('/api/v1',todoRoutes);

// Starting the server 
app.listen(PORT, () =>{
    console.log(`Server started at ${PORT}`);
})

//DB Connection
const dbConnect = require('./config/database');
dbConnect();

//Default route
app.get('/',(req,res) =>{
    res.send(`<h1> Welcome to the Homepage </h1>`)
})