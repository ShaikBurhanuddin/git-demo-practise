const mongoose = require('mongoose');

// Importing dotenv for process object to work
require('dotenv').config();

// Function to connect to database
const dbConnect = () =>{
    mongoose.connect(process.env.DATABASE_URL,{
        useNewUrlParser : true,
        useUnifiedTopology : true,
    })
    .then(() => console.log('DB Connected Sucessfully'))
    .catch((error) => {
        console.log('Issue in DB Connection');
        console.error(error.message)
        process.exit(1);
    });
}

//Exporting
module.exports = dbConnect;
