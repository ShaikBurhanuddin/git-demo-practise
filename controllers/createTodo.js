const Todo = require('../models/Todo')

exports.createTodo = async(req,res) => {

    try{
        // Destructuring data 
        const {title,description} = req.body;

        // Creating a newTodo and inserting in db 
        const response = await Todo.create({title,description});

        // Send a json response with a success flag 
        res.status(200).json(
            {
                success:true,
                data:response,
                message:'Entry created sucessfully'
            }
        );
    }
    // Catching error
    catch(err){
        console.log(err);
        res.status(500).json(
            {
                success:false,
                data:'internal server error',
                message:err.message,
            }
        )
    }

}