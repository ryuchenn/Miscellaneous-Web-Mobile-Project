const express = require('express');
const Playlist = require('../model/Playlist_md');
const Song = require('../model/Song_md')
const router = express.Router();

// Home Page
router.get('/', async (req, res) => {
    try {
        const songs = await Song.find();
        const playlist= await Playlist.find();
        return res.render('index.ejs', { songs, playlist });
    } catch (error) {
        console.error("Error fetching data: ", error);
        return res.status(500).send("Server Error!!");
    }
});

// Add new song to the songs collection
router.post('/add-song', async (req, res) => {
    try {
        const { title, artist, image } = req.body;
        const SongData = new Song({ Title: title, Artist: artist, Image: image });
        await SongData.save();
        res.redirect('/');
    } catch (error) {
        console.error("Error adding new song: ", error);
        res.status(500).send("Server Error");
    }
});

// add the song to the playlist
router.post('/add-to-playlist/:id', async (req, res) => {
    try {
        const SongData = await Song.findById(req.params.id);
        if (SongData) {
            const PlaylistData = new Playlist({
                Title: SongData.Title,
                Artist: SongData.Artist,
                Image: SongData.Image
            });
            await PlaylistData.save();
        }
        res.redirect('/');
    } catch (error) {
        console.error("Error adding to playlist: ", error);
        res.status(500).send("Server Error!!");
    }
});

// Remove song from playlist
router.post('/remove-from-playlist/:id', async (req, res) => {
    try {
        await Playlist.findByIdAndDelete(req.params.id);
        res.redirect('/');
    } catch (error) {
        console.error("Error removing from playlist: ", error);
        res.status(500).send("Server Error");
    }
});


module.exports = router;