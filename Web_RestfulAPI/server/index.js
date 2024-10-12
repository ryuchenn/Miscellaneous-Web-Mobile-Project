//////////// 1. Set up && 6. Environment Variables ////////////
require("dotenv").config();
const express = require('express')
const mongoose = require('mongoose')
const app = express()
mongoose.connect("mongodb+srv://" + process.env.DB_USER + ":" + process.env.DB_PASSWORD + "@" + process.env.DB_NAME + ".5nu9r.mongodb.net/" + process.env.DB_USE)
        .then(()=> console.log("Connect MongoDB Success!"))
        .catch(err => console.err("Connect MongoDB Error: "+ err))
app.use(express.json());
const { TaskSchema} = require('./model/assigment1_md');

//////////// 2. MongoDB and Mongoose ////////////
// Code at ./model/assigment1_md.js

// 2-1 Create schema && 2-2. Create table 
// CreateTaskModel(TaskSchema);

//////////// 3. API Routes && 4. Input Validation && 5. Error Handling ////////////
// Code at ./routes/assignment1_rt

// Import the route. 
app.use('/assignment1', require('./routes/assignment1_rt'))

//////////// 6. Testing ////////////
// Code at server/tests/assigment1.test.js


// Unit test don't run this
app.listen(process.env.DB_DEFAULT_PORT, () => {
    console.log("server is running")
})


// Unit test need to export this. 
// Expected an Express application object rather than an object that started the server.
module.exports = app;