const mongoose = require('mongoose');

/**
 * Song Schema
 * @param {string} Title - Name of the song
 * @param {string} Artist - Artist or band name
 * @param {string} Image - URL to an image related to the song
 */
const SongSchema = new mongoose.Schema({
    Title: {
        type: String,
        required: true
    },
    Artist: {
        type: String,
        required: true
    },
    Image: {
        type: String, // URL for the image
        required: true
    }
});

module.exports = mongoose.model('Song', SongSchema, 'Song');
