require("dotenv").config();
const express = require('express')
const mongoose = require('mongoose')
const path = require("path");
const app = express()
mongoose.connect("mongodb+srv://" + process.env.DB_USER + ":" + process.env.DB_PASSWORD + "@" + process.env.DB_NAME + ".5nu9r.mongodb.net/" + process.env.DB_USE)
        .then(()=> console.log("Connect MongoDB Success!"))
        .catch(err => console.err("Connect MongoDB Error: "+ err))
app.use(express.json({ limit: '15mb' }));  
app.use(express.urlencoded({ limit: '15mb', extended: true }));
app.use(express.static(path.join(__dirname, 'public'))); // Testing images file

// model
const { SongSchema } = require('./model/Song_md');
const { PlaySchema } = require('./model/Playlist_md');

// ejs setup
app.set("view engine", "ejs") // above the endpoints. 
app.set("views", path.join(__dirname, "views")) 

// router
app.use('/', require('./routes/Song_rt'))


app.listen(process.env.DB_DEFAULT_PORT, () => {
    console.log("Server is running")
})
module.exports = app;