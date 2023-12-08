const express = require('express');
const app = express();

//Loads all data in .env into process object, used in next line process.env.PORT (good practice for port)
require('dotenv').config();

//Taking port from env or by default 3000
const PORT = process.env.PORT || 3000;

// Middleware to parse json from req.body -> the json object in PUT req is read here
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
    res.send(`<h1> Welcome to the Appnetwise 08-12-2023 </h1>`)
})