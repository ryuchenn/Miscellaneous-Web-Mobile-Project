const mongoose = require('mongoose');

/**
 * Playlist Entry Schema
 * @param {string} Title - Name of the song
 * @param {string} Artist - Artist or band name
 * @param {string} Image - URL to an image related to the song
 */
const PlaylistSchema = new mongoose.Schema({
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

module.exports = mongoose.model('Playlist', PlaylistSchema, 'Playlist');
