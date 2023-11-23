const Todo = require('../models/Todo')

exports.getTodos = async(req,res) => {
    try{
        // Fetching all todos 
        const todos = await Todo.find({});

        // Response 
        res.status(200)
        .json({
            success : true,
            data : todos,
            message : 'Entire todo data is fetched',
        })

    }

    catch(err){
        console.error(err);
        res.status(500)
        .json({
            success : false,
            error : err.message,
            message : 'Server Error',
        })
    }
}

exports.getTodoById = async(req,res) => {

    try{
        //ID of the Todo
        
        const id = req.params.id;
        const todo = await Todo.findById({_id: id})

        //If data with that id not found
        if(!todo){
            return res.status(400)
            .json({
                success: false,
                message: 'Data with Id not found'
            })
        }
        //  Data found 
        res.status(200)
        .json({
            success: true,
            data: todo,
            message: `Todo with ${id} found`
        }) 
        

    }
    catch(err){
        res.status(500)
        .json({
            success: false,
            error: err.message,
            message: 'Server Error'
        })
    }
}